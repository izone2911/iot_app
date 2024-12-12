import 'package:flutter/material.dart';

import '../provider/_index.dart' show GlobalProvider;
import '../constant/_index.dart' show Paths;
import '../database/_index.dart' show WeatherData;
import '../network/network_handler.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';

class WeatherModel {
  double temperature, humidity;
  String timestamp,id;

  WeatherModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        temperature = json['temperature'],
        humidity = json['humidity'],
        timestamp = json['timestamp'];
}

// class WeatherProvider extends NetworkHandler with ChangeNotifier{

//   final Map<String, List<dynamic>> _map = {};

//   Map<String, List<dynamic>> get listItem => _map;

//   void addWeatherItem(String key, dynamic item) => _map[key] = item;

//   void getWeatherDataWithDay(String date) async {
//     networkRequest(
//         requestOptions: NetworkHandler.requestOptions.copyWith(
//           path: (Paths.getClassList + date)
//         ),
//         handleResponse: (response) {
//           dynamic data;

//           data = response.data;
//           List<dynamic> weatherData = json.decode(data);
//           addWeatherItem(date, weatherData);
//           print(date);
//           print(listItem[date]);
//           print("---------------");
//           print(listItem);
//           print("--------------------------------");
//         },
//         afterHandleResponse: () => notifyListeners());
//   }
// }


class WeatherProvider with ChangeNotifier {
  final Map<String, List<dynamic>> _map = {};

  Map<String, List<dynamic>> get listItem => _map;

  void addWeatherItem(String key, dynamic item) => _map[key] = item;

  Future<void> getWeatherDataWithDay(String date) async {
    final response = await NetworkHandler.dio.fetch(
      NetworkHandler.requestOptions.copyWith(
        baseUrl: Paths.serverUrl,
        path: (Paths.getClassList + date),
        method: 'GET',
        connectTimeout: const Duration(seconds: 2)
      ),
    );

    // Xử lý phản hồi
    dynamic data = response.data;
    List<dynamic> weatherData = json.decode(data);
    addWeatherItem(date, weatherData);
    print(date);
    print(listItem[date]);
    print("---------------");
    print(listItem);
    print("--------------------------------");

    notifyListeners();
  }
}