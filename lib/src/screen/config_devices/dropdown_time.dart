import 'package:flutter/material.dart';

class DropdownTimeList extends StatefulWidget {
  const DropdownTimeList({super.key});

  @override
  State<DropdownTimeList> createState() => _DropdownList();
}

class _DropdownList extends State<DropdownTimeList> {
  String? _selectedValue;
  final List<String> _options = ['1', '5', '10', '30', '60', '120'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          hint: const Text('1 phút'),
          value: _selectedValue,
          items: _options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text('$option phút'),
            );
          }).toList(),
          onChanged: (String? newValue) {
            print("Chạm");
            setState(() {
              _selectedValue = newValue;
            });
          },
        ),
      ],
    );
  }
}