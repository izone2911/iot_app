import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constant/_index.dart' show RoutePath;
import '../provider/_index.dart' as provider;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alertProvider =
        Provider.of<provider.AlertProvider>(context, listen: false);

    int? unreadCount =
        context.select((provider.AlertProvider p) => p.unreadCount$3);

    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            alertProvider.setAfterErrored();
            context.go(RoutePath.alert.absolute);
          },
          child: SizedBox(
            width: (unreadCount != null && unreadCount < 10) ? 32 : 35,
            height: 35,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                (unreadCount != null && unreadCount != 0)
                    ? Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: Text(
                          unreadCount > 99 ? "99+" : unreadCount.toString(),
                          style:
                              const TextStyle(color: Colors.white, fontSize: 7),
                        ))
                    : const SizedBox(),
                Row(
                  children: [
                    Icon(
                      (unreadCount != null && unreadCount != 0)
                          ? Icons.notifications
                          : Icons.notifications_none,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(
                        width:
                            (unreadCount != null && unreadCount < 10) ? 2 : 5),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
