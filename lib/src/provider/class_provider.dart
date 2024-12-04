import 'dart:ffi';

import 'package:flutter/material.dart';

import '../provider/_index.dart' show GlobalProvider;
import '../constant/_index.dart' show Paths;
import '../network/lazy_loading_handler.dart';
import '../network/network_handler.dart';
import 'dart:convert';

class ClassModel extends LazyLoadingModel {
  double temperature, humidity;
  String timestamp;

  ClassModel.fromJson(Map<String, dynamic> json, {required super.recordID})
      : temperature = json['temperature'],
        humidity = json['humidity'],
        timestamp = json['timestamp'];
}

class ClassProvider extends LazyLoadingHandler<ClassModel> with ChangeNotifier {
  @override
  List<ClassModel> get listModel => _listClassModel;
  final _listClassModel = <ClassModel>[];

  var page$1 = 0;
  final pageSize$1 = 5;

  @override
  void refreshOnList() => getClassList$1((page$1 = 0));
  @override
  void updateOnList() => getClassList$1((page$1 += 1));

  void getClassList$1(int page) async /**/
  {
    networkRequest(
        requestOptions: NetworkHandler.requestOptions.copyWith(
          path: Paths.getClassList,
          data: {
            "token": GlobalProvider.token,
            "pageable_request": {"page": page, "page_size": pageSize$1}
          },
        ),
        handleResponse: (response) {
          dynamic data, numRecords, classList, i;

          data = response.data['body'];
          numRecords = response.data['body'].length;
          // classList = data as List;
          classList = jsonDecode(data);

          classList = classList.sublist(0,20);

          for (i = 0; i < classList.length; i++) {
            insertToList(ClassModel.fromJson(classList[i],
                recordID: numRecords - pageSize$1 * page$1 - i));
          }
        },
        afterHandleResponse: () => notifyListeners());
  }
}
