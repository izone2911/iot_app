import 'package:flutter/foundation.dart';

class AlertData with ChangeNotifier {
  final Map<String, List<dynamic>> _alert = {
    "new": [],
    "esp_inside": [],
    "esp_outside": []
  };

  List? get newData => _alert["new"];
  List? get insideData => _alert["esp_inside"];
  List? get outsideData => _alert["esp_inside"];

  void addAlertData(String key, dynamic item) {
    _alert[key]!.add(item);
    _alert[key]!.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    notifyListeners();
  }
}