// DoDat Demo AlertScreen
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ndialog/ndialog.dart';
import '../../provider/_index.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  AlertScreenState createState() => AlertScreenState();
}

class AlertScreenState extends State<AlertScreen> {
  String statusText = "Status Text";
  bool isConnected = false;
  List<String> messages = [];
  // TextEditingController idTextController = TextEditingController();

  final MqttServerClient client = MqttServerClient(
      'a16rrf6y48w5mg-ats.iot.us-east-1.amazonaws.com', '',
      maxConnectionAttempts: 3);

  final String clientId = "FixedClientID";

  @override
  void dispose() {
    // idTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MQTT Alert Screen"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: _connect,
                  child: const Text("Connect to MQTT Broker")),
              const SizedBox(height: 10),
              Text(
                "Status: $statusText",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "Messages Received: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: messages.isEmpty
                    ? const Center(child: Text("No messages yet"))
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(messages[index]),
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }

  _connect() async {
    if (clientId.trim().isNotEmpty) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 0,
        dialogTransitionType: DialogTransitionType.Shrink,
        dismissable: false,
        title: const Text("Connecting"),
        message: const Text("Connecting to AWS IoT"),
      );
      progressDialog.setLoadingWidget(const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red),
      ));
      // progressDialog.setMessage(const Text("Connecting to AWS IoT"));
      // progressDialog.setTitle(const Text("Connecting"));
      progressDialog.show();

      isConnected = await mqttConnect(clientId.trim());
      progressDialog.dismiss();
    }
  }

  Future<bool> mqttConnect(String uniqueId) async {
    setStatus("Connecting MQTT Broker");

    ByteData rootCA = await rootBundle.load('assets/certs/AmazonRootCA1.pem');
    ByteData deviceCert =
        await rootBundle.load('assets/certs/DeviceCertificate.crt');
    ByteData privateKey = await rootBundle.load('assets/certs/PrivateKey.key');

    SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

    client.securityContext = context;

    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.port = 8883;
    client.secure = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connMess;

    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS IoT");

      const topic = "esp32/pub";
      client.subscribe(topic, MqttQos.atLeastOnce);

      client.updates!
          .listen((List<MqttReceivedMessage<MqttMessage?>> messages) {
        final MqttPublishMessage message =
            messages[0].payload as MqttPublishMessage;
        _processPayload(message);
      });

      return true;
    } else {
      return false;
    }
  }

  void setStatus(String content) {
    setState(() {
      statusText = content;
    });
  }

  void onConnected() {
    setStatus("Client connection was successful");
  }

  void onDisconnected() {
    setStatus("Client disconnected");
  }

  void _processPayload(MqttPublishMessage message) {
    try {
      final String payloadString =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      Map<String, dynamic> jsonPayload = json.decode(payloadString);

      String formattedMessage = "ID: ${jsonPayload['id']}, "
          "Humidity: ${jsonPayload['humidity']}%, "
          "Temperature: ${jsonPayload['temperature']}°C, "
          "Timestamp: ${jsonPayload['timestamp']}";

      setState(() {
        messages.add(formattedMessage);
      });
    } catch (e) {
      print("Error processing payload: $e");

      setState(() {
        messages.add("Error processing payload: $e");
      });
    }
  }
}
