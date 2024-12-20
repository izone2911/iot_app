import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quanlyhoctap/src/screen/config_devices/inside_sensor_form.dart';

import '../constant/_index.dart' show RoutePath;
import '../provider/_index.dart' as provider;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late provider.AwsIotProvider awsIotProvider =
      Provider.of<provider.AwsIotProvider>(context, listen: false);
  late provider.AlertData alertData =
      Provider.of<provider.AlertData>(context, listen: false);

  void _onRefresh() async {
    awsIotProvider.connect().then((isConnected) {
      if (isConnected) {
        awsIotProvider.publish("home_request","home_request");
        awsIotProvider.subscribe('inside_running', alertData);
        awsIotProvider.subscribe('inside_changed', alertData);
        awsIotProvider.subscribe('outside_running', alertData);
        awsIotProvider.subscribe('outside_changed', alertData);
        awsIotProvider.subscribe('esp32/pub', alertData);
        awsIotProvider.subscribe('esp32/pub_home_inside', alertData);
        awsIotProvider.subscribe('esp32/pub_home_outside', alertData);
        print("Subscribed to topics after successful connection.");
      } else {
        print("Failed to connect to MQTT broker.");
      }
    }).catchError((error) {
      print("Error connecting to MQTT broker: $error");
    });
    await Future.delayed(Duration(milliseconds: 2000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 231, 246),
      body: Consumer2<provider.AwsIotProvider, provider.AlertData>(
          builder: (context, awsIotProvider, alertData, child) {
        return SmartRefresher(
          enablePullDown: !awsIotProvider.dataAws['mqtt_connect'],
          header: WaterDropMaterialHeader(
            backgroundColor: const Color.fromARGB(255, 147, 198, 240),
            color: Colors.red,
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              !awsIotProvider.dataAws['mqtt_connect']
                  ? Container(
                      height: 30,
                      color: const Color.fromARGB(255, 147, 198, 240),
                      child: Text(
                          "Lost connect to server. Pull down to reconnect",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              backgroundColor:
                                  const Color.fromARGB(255, 147, 198, 240)),
                          textAlign: TextAlign.center),
                    )
                  : Container(
                      height: 30,
                      color: const Color.fromARGB(255, 147, 198, 240),
                    ),
              ElevatedButton(
                  onPressed: awsIotProvider.disconnect,
                  child: Text("Test disconnect to Server")),

              // giao diện của Trang chủ có thể cần SingleScroll .....

              /////////////////  Đây là hiển thị nhiệt độ hiện tại trên trang chủ///////////////////
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ////// Nhiệt độ trong nhà////// có kéo thả
                  Draggable(
                    childWhenDragging: Container(
                      width: 191,
                    ),
                    feedback: Container(
                      height: 150,
                      width: 170,
                      // color: const Color.fromARGB(255, 231, 39, 39),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 236, 240, 161),
                        borderRadius: BorderRadius.circular(
                            20), // Thiết lập border radius
                      ),
                      padding: const EdgeInsets.all(10),
                      margin:
                          const EdgeInsets.only(left: 14, right: 7, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Trong nhà",
                            style: TextStyle(
                                fontSize: 30,
                                color: const Color.fromARGB(255, 8, 74, 102)),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Nhiệt độ :",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${awsIotProvider.dataAws['esp32/pub_inside']['temperature']}°C",
                                style: TextStyle(
                                  fontSize: 21,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                "Độ ẩm :",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${awsIotProvider.dataAws['esp32/pub_inside']['humidity']}%",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      height: 150,
                      width: 170,
                      // color: const Color.fromARGB(255, 231, 39, 39),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 236, 240, 161),
                        borderRadius: BorderRadius.circular(
                            20), // Thiết lập border radius
                      ),
                      padding: const EdgeInsets.all(10),
                      margin:
                          const EdgeInsets.only(left: 14, right: 7, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Trong nhà",
                            style: TextStyle(
                                fontSize: 30,
                                color: const Color.fromARGB(255, 8, 74, 102)),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Nhiệt độ :",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${awsIotProvider.dataAws['esp32/pub_inside']['temperature']}°C",
                                style: TextStyle(
                                  fontSize: 21,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                "Độ ẩm :",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${awsIotProvider.dataAws['esp32/pub_inside']['humidity']}%",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  ////// Nhiệt độ ngoài trời////// có kéo thả
                  Draggable(
                    childWhenDragging: Container(),
                    feedback: Container(
                      height: 150,
                      width: 170,
                      // color: const Color.fromARGB(255, 231, 39, 39),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 146, 241, 153),
                        borderRadius: BorderRadius.circular(
                            20), // Thiết lập border radius
                      ),
                      padding: const EdgeInsets.all(10),
                      margin:
                          const EdgeInsets.only(left: 7, right: 14, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ngoài trời",
                            style: TextStyle(
                                fontSize: 30,
                                color: const Color.fromARGB(255, 8, 74, 102)),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Nhiệt độ :",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${awsIotProvider.dataAws['esp32/pub_outside']['temperature']}°C",
                                style: TextStyle(
                                  fontSize: 21,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                "Độ ẩm :",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${awsIotProvider.dataAws['esp32/pub_outside']['humidity']}%",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      height: 150,
                      width: 170,
                      // color: const Color.fromARGB(255, 231, 39, 39),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 146, 241, 153),
                        borderRadius: BorderRadius.circular(
                            20), // Thiết lập border radius
                      ),
                      padding: const EdgeInsets.all(10),
                      margin:
                          const EdgeInsets.only(left: 7, right: 14, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ngoài trời",
                            style: TextStyle(
                                fontSize: 30,
                                color: const Color.fromARGB(255, 8, 74, 102)),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Nhiệt độ :",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${awsIotProvider.dataAws['esp32/pub_outside']['temperature']}°C",
                                style: TextStyle(
                                  fontSize: 21,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                "Độ ẩm :",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${awsIotProvider.dataAws['esp32/pub_outside']['humidity']}%",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              //////////////////// Dùng Single Scroll hiển thị nhiệt độ Hà Nội ......
            ],
          )),
        );
      }),
    );
  }
}
