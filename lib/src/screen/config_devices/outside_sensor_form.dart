import 'package:flutter/material.dart';
import './dropdown_time.dart';

void outsideSensorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Cảm biến ngoài trời'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text('Trạng thái'),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          print('Bật/Tắt sensor ngoài trờitrời');
                        },
                        child: Text(
                          'Bật/Tắt',
                          style: TextStyle(color: Colors.green),
                        )),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      'Thời gian đo',
                      softWrap: true,
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          print('Chỉnh thời gian sensor ngoài trời');
                        },
                        child: DropdownTimeList()),
                  ],
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng modal
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
