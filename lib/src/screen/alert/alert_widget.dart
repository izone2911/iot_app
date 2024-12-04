import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/_index.dart' show AlertModel, AlertProvider;

class AlertWidget extends StatelessWidget {
  static String _convertTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  AlertWidget({super.key, required this.alertModel})
      : dateTime = _convertTime(alertModel.time),
        id = alertModel.id;

  final AlertModel alertModel;
  final String id, dateTime;

  @override
  Widget build(BuildContext context) {
    var _ = context.select((AlertProvider p) => p.getAlertsByID(id)?.status);

    return _alertBox(
      isUnread: alertModel.status == "UNREAD" ? true : false,
      child: ListTile(
        title: Column(
          children: [
            Row(children: [Expanded(child: _logo()), _date(dateTime)]),
            const SizedBox(height: 5),
            _type(alertModel.type),
            const Divider(),
            const SizedBox(height: 7),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _message(alertModel.message),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_detail()],
            )
          ],
        ),
      ),
    );
  }

  static Widget _alertBox({required Widget child, required bool isUnread}) =>
      Container(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          decoration: BoxDecoration(
            color: isUnread
                ? const Color.fromARGB(150, 255, 255, 255)
                : const Color.fromARGB(255, 255, 255, 255),
            border: Border.all(color: const Color.fromARGB(240, 224, 211, 244)),
            borderRadius: const BorderRadius.all(Radius.elliptical(12, 10)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(240, 224, 211, 244),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: child);

  static Text _logo() => const Text("HUST",
      style: TextStyle(
          color: Color.fromARGB(200, 198, 64, 78),
          fontSize: 11,
          fontWeight: FontWeight.bold));

  static Text _date(String time) => Text(time,
      style: const TextStyle(
        color: Color.fromARGB(255, 134, 134, 134),
        fontSize: 10,
      ));

  static Container _type(String type) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(type, overflow: TextOverflow.ellipsis));

  static Text _message(String message) => Text(
        '$message\n',
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      );

  static Container _detail() => Container(
        margin: const EdgeInsets.only(top: 5),
        child: const Text("Chi tiết",
            style: TextStyle(
                color: Color.fromARGB(225, 105, 168, 255),
                fontSize: 11,
                decoration: TextDecoration.underline,
                decorationColor: Color.fromARGB(225, 105, 168, 255))),
      );
}
