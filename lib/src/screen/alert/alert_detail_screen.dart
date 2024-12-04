import 'package:flutter/material.dart';
import '../../provider/_index.dart' show AlertModel;

class AlertDetailScreen extends StatelessWidget {
  static String _convertTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return 'vào hồi ${dateTime.hour}:${dateTime.minute}:${dateTime.second}, ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  AlertDetailScreen({super.key, required this.alertModel})
      : dateTime = _convertTime(alertModel.time);

  final AlertModel alertModel;
  final String dateTime;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: appBar(),
      body: _alertDetailBox(
        status: alertModel.status,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_typeBox(alertModel.type)]),
          Text(alertModel.message),
          Text('\n\nThời gian gửi: $dateTime')
        ]),
      ));

  static Widget _alertDetailBox({required Widget child, required status}) =>
      Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color.fromARGB(255, 224, 211, 244)),
            borderRadius: const BorderRadius.all(Radius.elliptical(12, 10)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 224, 211, 244),
                spreadRadius: 2,
                blurRadius: 3,
              ),
            ],
          ),
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(child: child));

  static AppBar appBar() => AppBar(
      title: const Text('Thông báo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
      backgroundColor: const Color.fromARGB(200, 255, 0, 0),
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      toolbarHeight: 55);

  static Widget _typeBox(type) => Container(
      padding: const EdgeInsets.only(left: 10, bottom: 5, right: 10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color.fromARGB(255, 210, 210, 210), width: 1.5))),
      child: Text(
        type,
        textAlign: TextAlign.center,
      ));
}
