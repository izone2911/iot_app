import 'package:flutter/foundation.dart';

class ConfigData with ChangeNotifier {
  final Map<String, dynamic> _config = {
    'inside_running': true,
    'inside_changed': 60*1000,
    'outside_running': false,
    'outside_changed': 60*1000,
  };

  Map<String, dynamic> get configData => _config;

  void addConfigData(String key, dynamic item) {
    _config[key]!.add(item);
    notifyListeners();
  }
}