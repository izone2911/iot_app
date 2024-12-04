import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../provider/_index.dart' show AuthProvider;

extension AuthDB on AuthProvider {
  static FlutterSecureStorage storage = const FlutterSecureStorage();
  static String key = "auth";

  Future<void> insert() async {
    await storage.write(key: key, value: serialize());
  }

  Future<void> read() async {
    // await storage.deleteAll();

    final data = await storage.read(key: key);
    if (data != null) {
      debugPrint(jsonDecode(data).toString());
      deserialize(data);
    }
  }
}
