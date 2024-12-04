import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../provider/_index.dart' show AlertProvider;
import '../../constant/_index.dart' show RoutePath;
import 'alert_detail_screen.dart';
import 'alert_widget.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => AlertState();
}

class AlertState extends State<AlertScreen> {
  late final ScrollController _controller;
  late final AlertProvider _alertProvider;

  void _scrollHandler() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      await Future<void>.delayed(const Duration(microseconds: 100),
          () => _alertProvider.getNotifications$1());
    }
  }

  Future<void> _onRefresh() async {
    _alertProvider.reInit();
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_scrollHandler);
    _alertProvider = Provider.of<AlertProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final alertsLength = context.select<AlertProvider, int>(
      (AlertProvider p) => p.alerts.length,
    );
    final alertsEnd = context.select<AlertProvider, bool>(
      (AlertProvider p) => p.isEnd$1,
    );
    final alertsError = context.select<AlertProvider, bool>(
      (AlertProvider p) => p.isErrored$1,
    );

    debugPrint('$alertsLength, $alertsEnd, $alertsError');

    return Scaffold(
      appBar: AlertDetailScreen.appBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            controller: _controller,
            itemCount: alertsLength + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == alertsLength) {
                if (alertsEnd || alertsError) {
                  return Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                        !alertsError
                            ? "Bạn không còn thông báo nào!"
                            : "Không thể kết nối Internet!",
                        style: const TextStyle(color: Colors.red)),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              } else {
                return GestureDetector(
                  onTap: () {
                    _alertProvider
                        .updateAlertStatus(_alertProvider.alerts[index]);
                    context.go(
                      RoutePath.alertDetail.absolute,
                      extra: _alertProvider.alerts[index],
                    );
                  },
                  child: AlertWidget(alertModel: _alertProvider.alerts[index]),
                );
              }
            }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_scrollHandler);
  }
}
