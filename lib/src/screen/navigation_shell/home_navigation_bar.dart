// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/_index.dart' as provider;
import 'package:sidebarx/sidebarx.dart';


class ScaffoldWithHomeNavigation extends StatelessWidget {
  const ScaffoldWithHomeNavigation({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 198, 240),
        // title: Text('Drawer Example'),
        // actions: [IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: () {
        //       _controller.toggleExtended();  // Mở ngăn kéo
        //     },
        //   ),]
        ),
      body: navigationShell,
      drawer: SidebarX(
        // controller: _controller,
        theme: SidebarXTheme(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: canvasColor,
            borderRadius: BorderRadius.circular(20),
          ),
          hoverColor: scaffoldBackgroundColor,
          textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          selectedTextStyle: const TextStyle(color: Colors.white),
          hoverTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          itemTextPadding: const EdgeInsets.only(left: 30),
          selectedItemTextPadding: const EdgeInsets.only(left: 30),
          itemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: canvasColor),
          ),
          selectedItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: actionColor.withOpacity(0.37),
            ),
            gradient: const LinearGradient(
              colors: [accentCanvasColor, canvasColor],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 30,
              )
            ],
          ),
          iconTheme: IconThemeData(
            color: Colors.white.withOpacity(0.7),
            size: 20,
          ),
          selectedIconTheme: const IconThemeData(
            color: Colors.white,
            size: 20,
          ),
        ),
        extendedTheme: const SidebarXTheme(
          width: 200,
          decoration: BoxDecoration(
            color: canvasColor,
          ),
        ),
        footerDivider: divider,
        headerBuilder: (context, extended) {
          return SizedBox(
            height: extended ? 200 : 70,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipOval(
                // borderRadius: BorderRadius.circular(110),
                child: Image.asset(
                  'assets/images/Ganja.jpg', 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        controller: SidebarXController(
            selectedIndex: navigationShell.currentIndex, extended: true),
        // controller: _controller,
        items: [
          SidebarXItem(
            icon: Icons.home,
            label: 'Trang chủ',
            onTap: () => navigationShell.goBranch(0),
          ),
          SidebarXItem(
            icon: Icons.insert_chart,
            label: 'Thống kê',
            onTap: () => navigationShell.goBranch(1),
          ),
          // SidebarXItem(
          //   icon: Icons.notifications,
          //   label: 'Thông báo',
          //   onTap: () => navigationShell.goBranch(2),
          // ),
          SidebarXItem(
            icon: Icons.edgesensor_high,
            label: 'Quản lý thiết bị',
            onTap: () => navigationShell.goBranch(2),
          ),
        ],
      ),
    );
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
