import 'dart:ffi';

import 'package:flutter/material.dart';

import '../provider/_index.dart' show GlobalProvider;
import '../constant/_index.dart' show Paths;
import '../network/lazy_loading_handler.dart';
import '../network/network_handler.dart';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';

class TemperatureModel extends LazyLoadingModel {
  double temperature;
  double timestamp;

  TemperatureModel.fromJson(Map<String, dynamic> json, {required super.recordID})
      : temperature = json['temperature'],
        timestamp = json['timestamp'];
}

class TemperatureProvider extends LazyLoadingHandler<TemperatureModel> with ChangeNotifier {
  @override
  List<TemperatureModel> get listModel => _listTemperatureModel;
  final _listTemperatureModel = <TemperatureModel>[];

  List<FlSpot> _spots = [];
  List<FlSpot> get spots => List.unmodifiable(_spots);

  @override
  void refreshOnList() => getTemperatureList$1(("28-11"));
  // @override
  // void updateOnList() => getClassList$1((page$1 += 1));

  void getTemperatureList$1(String getTime) async /**/
  {
    networkRequest(
        requestOptions: NetworkHandler.requestOptions.copyWith(
          path: Paths.getClassList,
          data: {
            "token": GlobalProvider.token,
          },
        ),
        handleResponse: (response) {
          dynamic data, numRecords, classList, i, tmpData;

          data = response.data['body'];
          numRecords = response.data['body'].length;
          classList = jsonDecode(data);

          classList = classList.sublist(0,30);
          
          for (i = 0; i < classList.length; i++) {
            String str = classList[i].timestamp.substring(0,5);
            if(str!=getTime) continue;
            tmpData = {
              'temperature': classList[i].temperature,
              'timestamp': double.parse(classList[i].timestamp.substring(11,13))*60*60+double.parse(classList[i].timestamp.substring(14,16))*60+double.parse(classList[i].timestamp.substring(14,19)),
            };
            insertToList(TemperatureModel.fromJson(tmpData,
                recordID: numRecords));
          }
          print(classList.length);
          List<dynamic> jsonArray = json.decode(tmpData);

          // Chuyển đổi thành List<FlSpot>
          _spots = jsonArray.map((item) {
            return FlSpot(item['temperature'], item['timestamp']);
          }).toList();

        },
        afterHandleResponse: () => notifyListeners());
  }
}
