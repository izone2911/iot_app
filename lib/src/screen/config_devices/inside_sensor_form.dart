import 'package:flutter/material.dart';
import './dropdown_time.dart';
import '../../provider/_index.dart' as provider;

provider.AwsIotProvider awsIotProvider = provider.AwsIotProvider(clientId: "FixedClientID");


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
                          // awsIotProvider.
                          print('Bật/Tắt sensor trong nhà');
                        },
                        child: Text(
                          'Kiểm tra',
                          style: TextStyle(color: const Color.fromARGB(255, 118, 21, 215)),
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
