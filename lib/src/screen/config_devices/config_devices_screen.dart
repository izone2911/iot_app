import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanlyhoctap/src/network/lazy_loading_widget.dart';

import '../../network/network_widget.dart';
import 'package:calendar_slider/calendar_slider.dart';
import './inside_sensor_form.dart';
import './outside_sensor_form.dart';

class ConfigDevicesScreen extends StatefulWidget {
  const ConfigDevicesScreen({super.key});

  @override
  State<ConfigDevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<ConfigDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 231, 246),
      
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 147, 198, 240),
          centerTitle: true,
          title: Text(
            'Trạng thái thiết bị',
          ),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  insideSensorDialog(context);
                  print('Tapped sensor inside');
                },
                child: Container(
                    width: width - 40,
                    decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 245, 243, 243),  // Màu nền
                      // border:
                      //     Border.all(color: Colors.blue, width: 0), // Viền
                      borderRadius: BorderRadius.circular(16), // Bo góc
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text('Cảm biến trong nhà', style: TextStyle(
                          color: const Color.fromARGB(255, 54, 70, 244),
                          fontSize: 20,
                        ),),
                        const Spacer(),
                        Text(
                          'Bật/Tắt',
                          style: TextStyle(color: Colors.green, fontSize: 25),
                        )
                      ],
                    )),
              ),

              SizedBox(height: 16),

              InkWell(
                onTap: () {
                  outsideSensorDialog(context);
                  print('Tapped sensor outside');
                },
                child: Container(
                    width: width - 40,
                    decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 245, 243, 243), // Màu nền
                      // border:
                      //     Border.all(color: Colors.blue, width: 0), // Viền
                      borderRadius: BorderRadius.circular(16), // Bo góc
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text('Cảm biến ngoài trời', style: TextStyle(
                          color: const Color.fromARGB(255, 54, 70, 244),
                          fontSize: 20,
                        ),),
                        const Spacer(),
                        Text(
                          'Bật/Tắt',
                          style: TextStyle(color: Colors.green, fontSize: 25),
                        )
                      ],
                    )),
              ),
            ],
          ),
        )));
  }
}
