import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/_index.dart' as provider;

class ScaffoldWithHomeNavigation extends StatelessWidget {
  const ScaffoldWithHomeNavigation({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final alertProvider = context.read<provider.AlertProvider>();

    int? unreadCount =
        context.select((provider.AlertProvider p) => p.unreadCount$3);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          if (index == 1) alertProvider.setAfterErrored();
          navigationShell.goBranch(index);
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Badge.count(
              count: unreadCount ?? 0,
              isLabelVisible: unreadCount != null,
              child: const Icon(Icons.notifications),
            ),
            label: 'Thông báo',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Tin nhắn',
          ),
        ],
      ),
    );
  }
}
