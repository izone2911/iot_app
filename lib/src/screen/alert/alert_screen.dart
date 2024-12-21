// DoDat Demo AlertScreen
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:ndialog/ndialog.dart';
import '../../provider/_index.dart' as provider;

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  AlertScreenState createState() => AlertScreenState();
}

class AlertScreenState extends State<AlertScreen> {
  late provider.AlertData alertData = Provider.of<provider.AlertData>(context);

  @override
  Widget build(BuildContext context) {
    return Consumer2<provider.AwsIotProvider, provider.AlertData>(
        builder: (context, awsIotProvider, alertData, child) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 217, 229, 240),
        body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color.fromARGB(255, 214, 231, 246),
            ),
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            child: ExpandableList()),
        // body: Text('check ')
      );
    });
  }
}

class ExpandableList extends StatelessWidget {
  const ExpandableList({super.key});

  @override
  Widget build(BuildContext context) {
    late provider.AlertData alertData =
        Provider.of<provider.AlertData>(context);
    List? allItems = alertData.allData;
    return ListView(
      children: allItems!
          .map((item) => ExpandableListItem(
                item: item,
              ))
          .toList(),
    );
  }
}

class ExpandableListItem extends StatelessWidget {
  final dynamic item;

  const ExpandableListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    late provider.AlertData alertData =
        Provider.of<provider.AlertData>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: item['type'] == 'Mới'
            ? const Color.fromARGB(255, 195, 218, 242)
            : const Color.fromARGB(255, 223, 233, 241),
      ),
      child: ExpansionTile(
      onExpansionChanged: (expanded) {
        if (expanded && item['type'] == 'Mới') {
          alertData.removeNews();
          alertData.changeItem(item, {
            ...item,
            'type': 'Đã đọc',
          });
        }
      },
      title: Row(children: [
        item['id'] == 'inside'
        ?Icon(
          Icons.home,
          color: Colors.yellow
        )
        :Icon(
          Icons.sunny,
          color: Colors.red,
        ),
        SizedBox(width: 16.0),
        item['type'] == 'Mới'
        ?Text(item['timestamp'].substring(11,19), style: TextStyle(fontWeight: FontWeight.bold))
        :Text(item['timestamp'].substring(11,19)),
        Spacer(),
        item['type'] == 'Mới'
        ?Icon(
          Icons.mark_chat_unread,
          color: Colors.red,
        )
        :Icon(
          Icons.mark_chat_read,
          color: Colors.green,
        ),
      ]),
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 10.0, bottom: 10.0),
            child: Row(
              children: [
                Text('Nhiệt độ: ${item['temperature']}'),
                SizedBox(width: 16.0),
                Text('Độ ẩm: ${item['humidity']}'),
              ],
            )),
      ],
    )
    );
  }
}
