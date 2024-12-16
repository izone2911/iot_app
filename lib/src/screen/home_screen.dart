import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quanlyhoctap/src/screen/config_devices/inside_sensor_form.dart';

import '../constant/_index.dart' show RoutePath;
import '../provider/_index.dart' as provider;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late provider.AwsIotProvider awsIotProvider;
  late provider.RealTimeData realTimeData;

  @override
  void initState() {
    super.initState();
    realTimeData = Provider.of<provider.RealTimeData>(context, listen: false);

    awsIotProvider = provider.AwsIotProvider(clientId: "FixedClientID");

    awsIotProvider.connect().then((isConnected) {
      if (isConnected) {
        awsIotProvider.subscribeRealTime('esp32/pub', realTimeData);
        print("Subscribed to topics after successful connection.");
      } else {
        print("Failed to connect to MQTT broker.");
      }
    }).catchError((error) {
      print("Error connecting to MQTT broker: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 231, 246),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<provider.RealTimeData>(
              builder: (context, realTimeData, child) {
                return Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Inside Sensor Data:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        'Temperature: ${realTimeData.realTime["inside"]!["temperature"]}'),
                    Text(
                        'Humidity: ${realTimeData.realTime["inside"]!["humidity"]}'),
                    Text(
                        'Timestamp: ${realTimeData.realTime["inside"]!["timestamp"]}'),
                    SizedBox(height: 20),
                    Text(
                      'Outside Sensor Data:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        'Temperature: ${realTimeData.realTime["outside"]!["temperature"]}'),
                    Text(
                        'Humidity: ${realTimeData.realTime["outside"]!["humidity"]}'),
                    Text(
                        'Timestamp: ${realTimeData.realTime["outside"]!["timestamp"]}'),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.go(RoutePath
                    .chart.absolute); // Điều hướng đến màn hình thống kê
              },
              child: Text('View Details'),
            ),

            /// Hiển thị thông tin nhiệt độ độ ẩm các vùng khác
          ],
        ),
      ),
    );
  }
}
