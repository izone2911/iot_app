import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quanlyhoctap/src/screen/config_devices/inside_sensor_form.dart';

import 'package:http/http.dart' as http;
import 'package:quanlyhoctap/src/screen/news/news_detail.dart';
import 'dart:convert';
import '../network/news_service.dart'; // Thêm dịch vụ lấy tin tức
import '../constant/news_model.dart'; // Thêm mô hình dữ liệu tin tức

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

  List<NewsModel> articles = []; // Biến lưu danh sách tin tức

  bool isLoadin = true;
  getNews() async {
    NewsApi newsApi = NewsApi();
    await newsApi.getNews();
    articles = newsApi.dataStore;
    setState(() {
      isLoadin = false;
    });
  }

  @override
  void initState() {
    getNews();
    super.initState();
  }

  void _onRefresh() async {
    awsIotProvider.connect().then((isConnected) {
      if (isConnected) {
        awsIotProvider.subscribe('inside_running', alertData);
        awsIotProvider.subscribe('inside_changed', alertData);
        awsIotProvider.subscribe('outside_running', alertData);
        awsIotProvider.subscribe('outside_changed', alertData);
        awsIotProvider.subscribe('esp32/pub', alertData);
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
      body: isLoadin
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer2<provider.AwsIotProvider, provider.AlertData>(
              builder: (context, awsIotProvider, alertData, child) {
              return SmartRefresher(
                enablePullDown: !awsIotProvider.dataAws['mqtt_connect'],
                header: WaterDropMaterialHeader(
                  backgroundColor: const Color.fromARGB(255, 147, 198, 240),
                  color: Colors.red,
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          if (!awsIotProvider.dataAws['mqtt_connect'])
                            Container(
                              height: 30,
                              color: const Color.fromARGB(255, 147, 198, 240),
                              child: Center(
                                child: Text(
                                  "Lost connection to server. Pull down to reconnect",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: awsIotProvider.disconnect,
                            child: Text("Test disconnect to Server"),
                          ),
                        ],
                      ),
                    ),
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 200.0,
                      backgroundColor: const Color.fromARGB(255, 214, 231, 246),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildTemperatureContainer(
                              title: "Trong nhà",
                              temperature: awsIotProvider
                                          .dataAws['esp32/pub_inside'] !=
                                      null
                                  ? "${awsIotProvider.dataAws['esp32/pub_inside']['temperature']}°C"
                                  : 'N/A',
                              humidity: awsIotProvider
                                          .dataAws['esp32/pub_inside'] !=
                                      null
                                  ? "${awsIotProvider.dataAws['esp32/pub_inside']['humidity']}%"
                                  : 'N/A',
                            ),
                            buildTemperatureContainer(
                              title: "Ngoài nhà",
                              temperature: awsIotProvider
                                          .dataAws['esp32/pub_outside'] !=
                                      null
                                  ? "${awsIotProvider.dataAws['esp32/pub_outside']['temperature']}°C"
                                  : 'N/A',
                              humidity: awsIotProvider
                                          .dataAws['esp32/pub_outside'] !=
                                      null
                                  ? "${awsIotProvider.dataAws['esp32/pub_outside']['humidity']}%"
                                  : 'N/A',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      // for home screen news
                      ListView.builder(
                        itemCount: articles.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewsDetail(newsModel: article),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      article.urlToImage!,
                                      height: 250,
                                      width: 400,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    article.title!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Divider(thickness: 2),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ]))
                  ],
                ),
              );
            }),
    );
  }

  Widget buildTemperatureContainer(
      {required String title,
      required String temperature,
      required String humidity}) {
    return Container(
      height: 150,
      width: 170,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 240, 161),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 14, right: 7, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 30,
              color: const Color.fromARGB(255, 8, 74, 102),
            ),
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
                temperature,
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
                humidity,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
