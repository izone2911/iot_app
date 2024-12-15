// DoDat Demo AlertScreen
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ndialog/ndialog.dart';
import '../../provider/_index.dart' as provider;

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  AlertScreenState createState() => AlertScreenState();
}

class AlertScreenState extends State<AlertScreen> {
  late provider.AlertData alertData;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text('trang thông báo'),
      ),
    );
  }
}
