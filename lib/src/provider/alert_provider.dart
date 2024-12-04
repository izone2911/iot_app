import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import '../constant/_index.dart' show Urls;
import 'global_provider.dart';

class AlertModel {
  final String id, fromID, toID;
  final String message, type, time;
  String status;

  AlertModel({
    required this.id,
    required this.fromID,
    required this.toID,
    required this.message,
    required this.type,
    required this.time,
    required this.status,
  });
}

class AlertProvider extends ChangeNotifier {
  static const _headers = <String, String>{'Content-Type': 'application/json'};
  static final Uri _getNotificationsUri = Uri.parse(Urls.getNotifications);
  static final Uri _markAsReadUri = Uri.parse(Urls.markNotificationAsRead);
  static final Uri _getUnreadCountUri =
      Uri.parse(Urls.getUnreadNotificationCount);

  final _storage = const FlutterSecureStorage();

  //
  final int _count$1 = 5;
  int _index$1 = 0;
  bool isEnd$1 = false;
  bool isErrored$1 = false;

  void getNotifications$1() async {
    String token = GlobalProvider.token;

    if (token != '' && !isEnd$1) {
      final String body = json.encode(<String, String>{
        "token": GlobalProvider.token,
        "index": _index$1.toString(),
        "count": _count$1.toString(),
      });
      try {
        final response = await http
            .post(_getNotificationsUri, headers: _headers, body: body)
            .timeout(const Duration(seconds: 3),
                onTimeout: () => http.Response('Error', 408));

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);
          List<dynamic> alerts = body['data'];

          for (var alert in alerts) {
            this.alerts.add(_convert$1(alert));
          }

          _index$1 += alerts.length;
          isEnd$1 = alerts.length < _count$1;
          isErrored$1 = false;
        }
      } on SocketException catch (_) {
        isErrored$1 = true;
      } finally {
        notifyListeners();
      }
    }
  }

  void markNotificationAsRead() async {
    String token = GlobalProvider.token;

    const String key = "ReadedAlerts";
    final String? data = await _storage.read(key: key);
    List<dynamic> readedAlerts = (data == null) ? [] : jsonDecode(data);

    if (token != '' && readedAlerts.isNotEmpty) {
      final String body = json.encode(<String, dynamic>{
        "token": GlobalProvider.token,
        "notification_ids": readedAlerts
      });

      try {
        final response = await http
            .post(_markAsReadUri, headers: _headers, body: body)
            .timeout(const Duration(seconds: 3),
                onTimeout: () => http.Response('Error', 408));

        if (response.statusCode == 200) {
          await _storage.write(key: key, value: jsonEncode([]));
          isErrored$1 = false;
        }
      } on SocketException catch (_) {
        isErrored$1 = true;
      } finally {
        notifyListeners();
      }
    }
  }

  int? unreadCount$3;
  void getUnreadNotificationCount$3() async {
    String token = GlobalProvider.token;

    if (token != '' && !isEnd$1) {
      final String body = json.encode(<String, String>{
        "token": GlobalProvider.token,
      });
      try {
        final response = await http
            .post(_getUnreadCountUri, headers: _headers, body: body)
            .timeout(const Duration(seconds: 3),
                onTimeout: () => http.Response('Error', 408));

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);
          unreadCount$3 = body['data'];
          isErrored$1 = false;
        }
      } on SocketException catch (_) {
        isErrored$1 = true;
        unreadCount$3 = null;
      } finally {
        notifyListeners();
      }
    }
  }

  void updateAlertStatus(AlertModel alertModel) async {
    if (alertModel.status == "UNREAD" && unreadCount$3 != null) {
      unreadCount$3 = unreadCount$3! - 1;
    }
    alertModel.status = "READ";
    notifyListeners();

    const String key = "ReadedAlerts";
    final String? data = await _storage.read(key: key);
    List<dynamic> readedAlerts = (data == null) ? [] : jsonDecode(data);

    if (!readedAlerts.contains(alertModel.id)) {
      readedAlerts.add(alertModel.id);
    }

    await _storage.write(key: key, value: jsonEncode(readedAlerts));
  }

  void setAfterErrored() {
    isErrored$1 = false;
    markNotificationAsRead();
    getUnreadNotificationCount$3();
    getNotifications$1();
  }

  void reInit() async {
    _index$1 = 0;
    alerts.clear();
    isEnd$1 = false;
    notifyListeners();
    markNotificationAsRead();
    await Future<void>.delayed(const Duration(seconds: 1));
    getUnreadNotificationCount$3();
    getNotifications$1();
  }

  final List<AlertModel> alerts = [];
  AlertModel? getAlertsByID(String id) {
    int index = alerts.indexWhere((alert) => alert.id == id);
    if (index != -1) {
      return alerts[index];
    }
    return null;
  }

  AlertModel _convert$1(dynamic json) => AlertModel(
      id: json['id'].toString(),
      fromID: json['from_user'].toString(),
      toID: json['to_user'].toString(),
      message: json['message'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      time: json['sent_time'] as String);
}
