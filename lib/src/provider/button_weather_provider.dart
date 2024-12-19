import 'package:flutter/material.dart';

class ButtonWeatherProvider with ChangeNotifier {
  final Map<String, dynamic> _buttonWeather = {
    'button_inside': true,
    'button_outside': false,
    'color_active': const Color.fromARGB(255, 4, 200, 200),
    'color_inactive': const Color.fromARGB(255, 139, 139, 140),
  };

  Map<String, dynamic> get getData => _buttonWeather;

  void addData(String key, dynamic item) {
    _buttonWeather[key] = item;
    notifyListeners();
  }

  void addDataWithoutNotify(String key, dynamic item) {
    _buttonWeather[key] = item;
  }
}