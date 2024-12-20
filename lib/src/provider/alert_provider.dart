import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constant/urls.dart';
import '../network/network_handler.dart';

class AlertData with ChangeNotifier {
  final Map<String, dynamic> _alert = {
    "new": [],
    "esp": [],
    "color_new": Colors.red,
    "color_old": Colors.green,
    "font_old": FontWeight.w400,
    "font_new": FontWeight.bold,
    "fontsize_old": 14.0,
    "fontsize_new": 16.0,
  };

  List? get newData => _alert["new"];
  List? get allData => _alert["esp"];
  dynamic get colorData => _alert;

  void addAlertData(String key, dynamic item) {
    _alert[key]!.add(item);
    _alert[key]!.sort((a, b) {
      String timestampA = a['timestamp'] as String; 
      String timestampB = b['timestamp'] as String; 
      return timestampB.compareTo(timestampA);
    });
    notifyListeners();
  }

  void addAlertDataNoNotify(String key, dynamic item) {
    _alert[key]!.add(item);
    _alert[key]!.sort((a, b) {
      String timestampA = a['timestamp'] as String; 
      String timestampB = b['timestamp'] as String; 
      return timestampB.compareTo(timestampA);
    });
  }

  void changeItem(dynamic oldItem, dynamic newItem) {
    final index = _alert['esp'].indexOf(oldItem);
    _alert['esp'][index] = newItem;
    notifyListeners();
  }

  void removeNews() {
    _alert['new'].removeLast();
  }

  void changeAlertDataNoNotify(String key, dynamic item) {
    _alert[key] = item;
    _alert[key]!.sort((a, b) {
      String timestampA = a['timestamp'] as String; 
      String timestampB = b['timestamp'] as String; 
      return timestampB.compareTo(timestampA);
    });
  }
}
