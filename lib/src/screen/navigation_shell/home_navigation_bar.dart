// ignore_for_file: unused_local_variable

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/_index.dart' as provider;
import 'package:sidebarx/sidebarx.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../provider/weather_provider.dart';

import '../alert/alert_screen.dart';

class ScaffoldWithHomeNavigation extends StatefulWidget {
  const ScaffoldWithHomeNavigation({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithHomeNavigation> createState() =>
      _ScaffoldWithHomeNavigation();
}

class _ScaffoldWithHomeNavigation extends State<ScaffoldWithHomeNavigation> {
  late provider.AwsIotProvider awsIotProvider =
      Provider.of<provider.AwsIotProvider>(context, listen: false);
  late provider.AlertData alertData =
      Provider.of<provider.AlertData>(context, listen: false);
  late provider.WeatherProvider weatherProvider =
      Provider.of<WeatherProvider>(context, listen: false);

  bool haveNotifications = true;

  @override
  void initState() {
    super.initState();
    alertData = Provider.of<provider.AlertData>(context, listen: false);
    awsIotProvider =
        Provider.of<provider.AwsIotProvider>(context, listen: false);

    awsIotProvider.connect().then((isConnected) {
      if (isConnected) {
        awsIotProvider.publish("home_request", "home_request");
        awsIotProvider.subscribe('inside_running', alertData);
        awsIotProvider.subscribe('inside_changed', alertData);
        awsIotProvider.subscribe('outside_running', alertData);
        awsIotProvider.subscribe('outside_changed', alertData);
        awsIotProvider.subscribe('esp32/pub', alertData);
        awsIotProvider.subscribe('esp32/pub_home_inside', alertData);
        awsIotProvider.subscribe('esp32/pub_home_outside', alertData);
        print("Subscribed to topics after successful connection.");
      } else {
        print("Failed to connect to MQTT broker.");
      }
    }).catchError((error) {
      print("Error connecting to MQTT broker: $error");
    });

    DateTime selectedDate = DateTime.now();
    String selectedDateString =
        '${DateTime.now().toString().substring(8, 10)}-${DateTime.now().toString().substring(5, 7)}-${DateTime.now().toString().substring(0, 4)}';
    fetchWeatherData(selectedDateString);
  }

  Future<void> fetchWeatherData(String date) async {
    await weatherProvider.getWeatherDataWithDay(date);
    dynamic newWeatherData = weatherProvider.listItem[date]!.map((item) {
      item['type'] = 'Đã đọc';
      return item;
    }).toList();
    alertData.changeAlertDataNoNotify('esp', newWeatherData);
  }

  @override
  Widget build(BuildContext context) {
    final navigationShell = widget.navigationShell;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý thời tiết', style: TextStyle(color: const Color.fromARGB(255, 198, 0, 195))),
        backgroundColor: const Color.fromARGB(255, 147, 198, 240),
        actions: [
          Consumer2<provider.AlertData, provider.AwsIotProvider>(
            builder: (context, alertData, awsIotProvider, child) {
              return IconButton(
                icon: Icon(
                  alertData.newData!.isNotEmpty
                      ? Icons.notifications_active
                      : Icons.notifications_none,
                  color:
                      alertData.newData!.isNotEmpty ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  alertData.changeExpandNoNotify(
                      "is_expanded", !alertData.isExpand);
                  alertData.isExpand
                      ? navigationShell.goBranch(4)
                      : navigationShell.goBranch(alertData.preBranch);
                  alertData.isExpand
                      ? alertData.changeBranch(
                          "branch_pre", alertData.nowBranch, "branch_now", 4)
                      : alertData.changeBranch(
                          "branch_pre", 4, "branch_now", alertData.preBranch);
                },
              );
            },
          ),
        ],
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
            onTap: () {
              navigationShell.goBranch(0);
              alertData.changeBranch(
                  "branch_pre", alertData.nowBranch, "branch_now", 0);
              alertData.changeExpandNoNotify("is_expanded", false);
            },
          ),
          SidebarXItem(
            icon: Icons.insert_chart,
            label: 'Thống kê',
            onTap: () {
              navigationShell.goBranch(1);
              alertData.changeBranch(
                  "branch_pre", alertData.nowBranch, "branch_now", 1);
              alertData.changeExpandNoNotify("is_expanded", false);
            },
          ),
          SidebarXItem(
            icon: Icons.edgesensor_high,
            label: 'Quản lý thiết bị',
            onTap: () {
              navigationShell.goBranch(2);
              alertData.changeBranch(
                  "branch_pre", alertData.nowBranch, "branch_now", 2);
              alertData.changeExpandNoNotify("is_expanded", false);
            },
          ),
          SidebarXItem(
            icon: Icons.announcement,
            label: 'Thời tiết',
            onTap: () {
              navigationShell.goBranch(3);
              alertData.changeBranch(
                  "branch_pre", alertData.nowBranch, "branch_now", 3);
              alertData.changeExpandNoNotify("is_expanded", false);
            },
          ),
        ],

        footerBuilder: (context, extended) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      if (extended)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Đăng xuất',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
