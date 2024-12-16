import 'dart:convert';

import 'package:flutter/material.dart';
import './dropdown_time.dart';
import '../../provider/_index.dart' as provider;
import 'package:provider/provider.dart';


void insideSensorDialog(BuildContext context) {
  var awsIotProvider = Provider.of<provider.AwsIotProvider>(context, listen: false);
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
                    onTap: () async {
                      // Hiển thị biểu tượng loading
                      showDialog(
                        context: context,
                        barrierDismissible: false, // Không cho phép đóng khi nhấn bên ngoài
                        builder: (BuildContext context) {
                          return const Center(child: CircularProgressIndicator());
                        },
                      );

                      awsIotProvider.publish("check_inside", jsonEncode({"check inside":""}));
                      await Future.delayed(Duration(milliseconds: 800)); 

                      if (context.mounted) {
                        // Đóng dialog loading
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          awsIotProvider.dataAws['inside_running']['running']
                          ?SnackBar(
                            content: const Text('Đã kiểm tra. Cảm biến đang bật'),
                            duration: const Duration(seconds: 2),
                          )
                          :SnackBar(
                            content: const Text('Đã kiểm tra. Cảm biến đang tắt'),
                            duration: const Duration(seconds: 2),
                          )
                        );
                      }
                    },
                    child: Text(
                      'Kiểm tra',
                      style: TextStyle(color: const Color.fromARGB(255, 118, 21, 215)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('Thời gian đo', softWrap: true),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      print('Chỉnh thời gian sensor trong nhà');
                    },
                    child: DropdownTimeList(),
                  ),
                ],
              ),
            ),
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