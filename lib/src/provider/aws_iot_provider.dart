
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '_index.dart';
import 'alert_provider.dart';

class AwsIotProvider {

  final Map<String, dynamic> _map = {
    'inside_running': {},
    'inside_changed': {},
    'esp32/pub': {}
  };

  Map<String, dynamic> get dataAws => _map;

  void addDataAws(String key, dynamic item) {
      _map[key] = [item];
  }


  final String brokerUrl = 'a16rrf6y48w5mg-ats.iot.us-east-1.amazonaws.com';
  final int port = 8883;
  final String clientId;
  final String rootCAPath = 'assets/certs/AmazonRootCA1.pem';
  final String deviceCertPath = 'assets/certs/DeviceCertificate.crt';
  final String privateKeyPath = 'assets/certs/PrivateKey.key';

  late MqttServerClient client;

  final AlertData alertData = AlertData();

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
      client.keepAlivePeriod = 20;

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

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
      final recMessage = messages![0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
      addDataAws(topic, payload);
      if(topic=='esp32/pub') {
        alertData.addAlertData('unread', payload);// Thêm payload nhận được vào thông báo chưa đọc
      }
      // print("Received message: $payload from topic: ${messages[0].topic}");
    });
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
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
