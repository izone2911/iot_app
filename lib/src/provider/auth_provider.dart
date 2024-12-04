import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../database/_index.dart';
import '../constant/_index.dart' as constant;
import 'global_provider.dart';

class AuthProvider with ChangeNotifier {
  String? ten;
  String? errorMessage;
  bool isAuth = false;

  void fromJson(Map<String, dynamic> json) => {
        ten = json['ten'] as String,
        isAuth = json['isAuth'] as bool,
      };
  Map<String, dynamic> toMap() => <String, dynamic>{
        'ten': ten,
        'isAuth': isAuth,
      };

  serialize() => json.encode(toMap());
  deserialize(String json) => fromJson(jsonDecode(json));

  Future<bool> login(data) async {
    data = {
      ...data,
      'deviceId': 1 // device's MAC, maybe...
    };

    final response = await http.post(
      Uri.parse(constant.Urls.login),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.body);
      GlobalProvider.token = res['token'];
      ten = res['ten'];
      isAuth = true;
      insert();
      debugPrint("${response.body} login");
      notifyListeners();
      return true;
    } else {
      errorMessage = response.body;
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkLogin() async {
    await Future<void>.delayed(const Duration(seconds: 2), () => read());
    return isAuth;
  }
}
