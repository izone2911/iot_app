import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanlyhoctap/src/network/lazy_loading_widget.dart';

import '../../provider/_index.dart' show ClassProvider;
import '../../network/network_widget.dart';

// ignore: must_be_immutable
class ClassScreen extends StatelessWidget {
  ClassScreen({super.key});

  late ClassProvider classProvider;

  @override
  Widget build(BuildContext context) {
    classProvider = Provider.of(context, listen: false);

    return NetworkWidget<ClassProvider>(
      onReload: () => classProvider.getClassList$1(0),
      child: Scaffold(
        bottomNavigationBar: ElevatedButton(
          onPressed: () => classProvider.getClassList$1(0),
          child: const Text("Press Me!"),
        ),
        body: Center(
          child: LazyLoadingWidget<ClassProvider>(
            getWidget: (index) => Container(
              height: 140,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Thời gian',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    classProvider.listModel[index].timestamp,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'Nhiệt độ: ${classProvider.listModel[index].temperature.toString()}°C',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Độ ẩm: ${classProvider.listModel[index].humidity.toString()}%',
                    style: const TextStyle(fontSize: 16),
                  ),
                ]),
            ),
          ),
        ),
      ),
    );
  }
}
