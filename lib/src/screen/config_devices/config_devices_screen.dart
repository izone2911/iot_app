// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanlyhoctap/src/network/lazy_loading_widget.dart';

import '../../network/network_widget.dart';
import 'package:calendar_slider/calendar_slider.dart';
import '../../provider/_index.dart' as provider;
import './inside_sensor_form.dart';
import './outside_sensor_form.dart';


class ConfigDevicesScreen extends StatefulWidget {
  const ConfigDevicesScreen({super.key});

  @override
  State<ConfigDevicesScreen> createState() =>
      _ConfigDevicesScreen();
}

class _ConfigDevicesScreen extends State<ConfigDevicesScreen> {
  // late ConfigData configData;
  
  @override
  void initState() {
    super.initState();
    var awsIotProvider = Provider.of<provider.AwsIotProvider>(context, listen: false);
    awsIotProvider.publish("check_inside", jsonEncode({"check inside":""}));
    awsIotProvider.publish("check_outside", jsonEncode({"check outside":""}));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final height = MediaQuery.of(context).size.height;

    return Consumer<provider.AwsIotProvider>(
      builder: (context, awsIotProvider, child){
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
                        awsIotProvider.dataAws['inside_running']['running']
                        ?Text(
                          'Bật',
                          style: TextStyle(color: Colors.green, fontSize: 25),
                        )
                        :Text(
                          'Tắt',
                          style: TextStyle(color: Colors.red, fontSize: 25),
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
                        awsIotProvider.dataAws['outside_running']['running']
                        ?Text(
                          'Bật',
                          style: TextStyle(color: Colors.green, fontSize: 25),
                        )
                        :Text(
                          'Tắt',
                          style: TextStyle(color: Colors.red, fontSize: 25),
                        )
                      ],
                    )),
              ),
            ],
          ),
        )));
      });
  }
}
