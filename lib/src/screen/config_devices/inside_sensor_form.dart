import 'package:flutter/material.dart';
import './dropdown_time.dart';

void insideSensorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Cảm biến trong nhà'),
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
                          print('Bật/Tắt sensor trong nhà');
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
                          print('Chỉnh thời gian sensor trong nhà');
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
