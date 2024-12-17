import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
// import 'package:quanlyhoctap/src/provider/realtime_provider.dart';
import '_index.dart';
// import 'alert_provider.dart';

class AwsIotProvider with ChangeNotifier {
  final Map<String, dynamic> _map = {
    'inside_running': {'running': true, 'time': '10'},
    'inside_changed': {},
    'outside_running': {'running': true, 'time': '10'},
    'outside_changed': {},
    'esp32/pub_inside': {
      "id": "inside",
      "humidity": 0,
      "temperature": 0,
      "timestamp": "",
    },
    'esp32/pub_outside': {
      "id": "outside",
      "humidity": 0,
      "temperature": 0,
      "timestamp": "",
    }
  };

  Map<String, dynamic> get dataAws => _map;

  void addDataAws(String key, dynamic item) {
    _map[key] = item;
    notifyListeners();
  }

  bool checkInsideRunning = false;
  bool checkOutsideRunning = false;
  Timer? timer;

  final String brokerUrl = 'a16rrf6y48w5mg-ats.iot.us-east-1.amazonaws.com';
  final int port = 8883;
  final String clientId;
  final String rootCAPath = 'assets/certs/AmazonRootCA1.pem';
  final String deviceCertPath = 'assets/certs/DeviceCertificate.crt';
  final String privateKeyPath = 'assets/certs/PrivateKey.key';

  late MqttServerClient client;

  // final alertData = Provider.of<AlertData>(context, listen: false);

  AwsIotProvider({required this.clientId}) {
    client = MqttServerClient(brokerUrl, clientId, maxConnectionAttempts: 3);
  }

  Future<bool> connect() async {
    try {
      // Load certs
      ByteData rootCA = await rootBundle.load(rootCAPath);
      ByteData deviceCert = await rootBundle.load(deviceCertPath);
      ByteData privateKey = await rootBundle.load(privateKeyPath);

      // Setup security context
      SecurityContext context = SecurityContext.defaultContext;
      context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
      context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
      context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

      // Configure MQTT client
      client.securityContext = context;
      client.port = port;
      client.secure = true;
      client.logging(on: true);
      client.keepAlivePeriod = 60;

      // Set connection callbacks
      client.onConnected = onConnected;
      client.onDisconnected = onDisconnected;

      // Set connection message
      final MqttConnectMessage connMess =
          MqttConnectMessage().withClientIdentifier(clientId).startClean();
      client.connectionMessage = connMess;

      // Connect to broker
      await client.connect();

      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        print("Connected to AWS IoT");
        return true;
      } else {
        print("Connection failed: ${client.connectionStatus}");
        return false;
      }
    } catch (e) {
      print("Error connecting to AWS IoT: $e");
      return false;
    }
  }

  void subscribe(String topic, AlertData alertData) {
    client.subscribe(topic, MqttQos.atLeastOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
      final recMessage = messages![0].payload as MqttPublishMessage;
      final payload = jsonDecode(
          MqttPublishPayload.bytesToStringAsString(recMessage.payload.message));
      if (topic == messages[0].topic) {
        print("$payload  with  $topic");
        if (topic == 'esp32/pub' && payload['id'] == 'inside') {
          addDataAws("esp32/pub_inside", payload);
        }
        if (topic == 'esp32/pub' && payload['id'] == 'outside') {
          addDataAws("esp32/pub_outside", payload);
        }
        if (topic != 'esp32/pub' && topic != 'inside_changed' && topic != 'outside_changed') addDataAws(topic, payload);
        
        if(topic == 'inside_changed'){
          addDataAws(topic, {'change_time': ((int.parse(payload['change_time']))~/60000).toString() });
        }

        if(topic == 'outside_changed'){
          addDataAws(topic, {'change_time': ((int.parse(payload['change_time']))~/60000).toString() });
        }

        if(topic == 'inside_running') {
          print(((int.parse(payload['time']))~/60000).toString());
          addDataAws('inside_changed', {'change_time': ((int.parse(payload['time']))~/60000).toString() });
          checkInsideRunning = true;
        }
        if(topic == 'outside_running') {
          addDataAws('outside_changed', {'change_time': (int.parse(payload['time'])~/60000).toString() });
          checkOutsideRunning = true;
        }
      }
      if (topic == 'esp32/pub') {
        // Thêm payload nhận được vào thông báo chưa đọc
        alertData.addAlertData("unread", payload);
        // print("Received message: $payload from topic: ${messages[0].topic}");
      }
    });
  }


  void publish(String topic, String message, {int waitTime=800}) {

    if(topic == 'check_inside') checkInsideRunning = false;
    if(topic == 'check_outside') checkOutsideRunning = false;

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

    timer = Timer(Duration(milliseconds: waitTime), () {
      if (!checkInsideRunning) {
        addDataAws("inside_running", {'running': false, 'time': '10'});
      }
      if (!checkOutsideRunning) {
        addDataAws("outside_running", {'running': false, 'time': '10'});
      }
      // Hủy timer
      timer?.cancel();
    });
  }

  void onConnected() {
    print("Client connection was successful");
  }

  void onDisconnected() {
    print("Client disconnected");
  }

  void disconnect() {
    client.disconnect();
    print("Disconnected from AWS IoT");
  }
}
