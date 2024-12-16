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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 231, 246),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<provider.AwsIotProvider>(
              builder: (context, awsIotProvider, child) {
                return Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      'Inside Sensor Data:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    Text(
                        'Temperature: ${awsIotProvider.dataAws['esp32/pub_inside']["temperature"]}'),
                    Text(
                        'Humidity: ${awsIotProvider.dataAws['esp32/pub_inside']["humidity"]}'),
                    Text(
                        'Timestamp: ${awsIotProvider.dataAws['esp32/pub_inside']["timestamp"]}'),
                    SizedBox(height: 20),
                    Text(
                      'Outside Sensor Data:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        'Temperature: ${awsIotProvider.dataAws['esp32/pub_outside']["temperature"]}'),
                    Text(
                        'Humidity: ${awsIotProvider.dataAws['esp32/pub_outside']["humidity"]}'),
                    Text(
                        'Timestamp: ${awsIotProvider.dataAws['esp32/pub_outside']["timestamp"]}'),
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
