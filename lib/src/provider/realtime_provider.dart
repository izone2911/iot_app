import 'package:flutter/foundation.dart';

class RealTimeData with ChangeNotifier {
  final Map<String, Map<String, dynamic>> _realTime = {
    "inside": {
      "humidity": 0,
      "temperature": 0,
      "timestamp": "",
    },
    "outside": {
      "humidity": 0,
      "temperature": 0,
      "timestamp": "",
    },
  };

  Map<String, Map<String, dynamic>> get realTime => _realTime;

  void changeRealTimeData(
    String key,
    double temperature,
    int humidity,
    String timestamp,
  ) {
    _realTime[key] = {
      "temperature": temperature,
      "humidity": humidity,
      "timestamp": timestamp,
    };
    notifyListeners();
  }
}
