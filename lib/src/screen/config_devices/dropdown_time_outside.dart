import 'dart:convert';
import 'package:provider/provider.dart';

import '../../provider/_index.dart' as provider;
import 'package:flutter/material.dart';

class DropdownTimeListOutside extends StatefulWidget {
  const DropdownTimeListOutside({super.key});

  @override
  State<DropdownTimeListOutside> createState() => _DropdownList();
}

class _DropdownList extends State<DropdownTimeListOutside> {
  final List<String> _options = ['1', '5', '10', '30', '60', '120'];

  @override
  Widget build(BuildContext context) {
    return Consumer<provider.AwsIotProvider>(
        builder: (context, awsIotProvider, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            hint: Text('${awsIotProvider.dataAws['outside_changed']['change_time']}'),
            value: awsIotProvider.dataAws['outside_changed']['change_time'],
            items: _options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text('$option phút'),
              );
            }).toList(),
            onChanged: (String? newValue) async {
              if(newValue!=null && newValue != awsIotProvider.dataAws['outside_changed']['change_time']) {
                showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Không cho phép đóng khi nhấn bên ngoài
                          builder: (BuildContext context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );
                awsIotProvider.publish(
                            "change_time_outside", jsonEncode({"change_time":  (int.parse(newValue)*60000).toString()   }));
                await Future.delayed(Duration(milliseconds: 800));

                if (context.mounted) {
                          // Đóng dialog loading
                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                              awsIotProvider.dataAws['outside_changed']
                                      ['change_time'] == newValue
                                  ? SnackBar(
                                      content: const Text(
                                          'Đã thay đổi thời gian đo'),
                                      duration: const Duration(seconds: 2),
                                    )
                                  : SnackBar(
                                      content: const Text(
                                          'Thay đổi thời gian đo thất bại'),
                                      duration: const Duration(seconds: 2),
                                    ));
                        }
              }
            },
          ),
        ],
      );
    });
  }
}