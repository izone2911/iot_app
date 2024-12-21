import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constant/urls.dart';
import '../network/network_handler.dart';

class AlertData with ChangeNotifier {
  final Map<String, dynamic> _alert = {
    "new": [],
    "esp": [],
    "is_expanded": false,
    "branch_now": 0,
    "branch_pre": 0
  };

  List? get newData => _alert["new"];
  List? get allData => _alert["esp"];
  dynamic get isExpand => _alert["is_expanded"];
  dynamic get preBranch => _alert['branch_pre'];
  dynamic get nowBranch => _alert['branch_now'];

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

  void changeExpandNoNotify(String key, dynamic item) {
    _alert[key] = item; 
  }

  void changeBranch(String key1, int item1, String key2, int item2){
    _alert[key1] = item1;
    _alert[key2] = item2;
    print("${_alert['branch_pre']}------${_alert['branch_now']}------${_alert['branch_pre'].runtimeType}------${_alert['branch_now'].runtimeType}------${_alert['is_expanded']}");
  }
}
