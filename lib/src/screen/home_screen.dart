import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constant/_index.dart' show RoutePath;
import '../provider/_index.dart' as provider;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.go(RoutePath.chart.absolute);
          },
          child: const SizedBox(
            child: Text('Home'),
          ),
        ),
      ),
    );
  }
}
