import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constant/_index.dart' as constant;
import 'provider/_index.dart' as provider;
import 'screen/_index.dart' as screen;

final GoRouter _router = GoRouter(
  initialLocation: constant.RoutePath.home.absolute,
  routes: [
    GoRoute(
      name: constant.RoutePath.login.name,
      path: constant.RoutePath.login.relative,
      builder: (_, __) => screen.LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) => screen.ScaffoldWithHomeNavigation(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: constant.RoutePath.home.name,
              path: constant.RoutePath.home.relative,
              builder: (_, __) => const screen.HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(routes: [
          GoRoute(
              name: constant.RoutePath.chart.name,
              path: constant.RoutePath.chart.relative,
              builder: (_, __) => const screen.WeatherScreen())
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              name: constant.RoutePath.config.name,
              path: constant.RoutePath.config.relative,
              builder: (_, __) => screen.ConfigDevicesScreen())
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            name: constant.RoutePath.world.name,
            path: constant.RoutePath.world.relative,
            builder: (_, __) => const screen.WorldWeatherScreen(),
          )
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            name: constant.RoutePath.alert.name,
            path: constant.RoutePath.alert.relative,
            builder: (_, __) => const screen.AlertScreen(),
          )
        ])
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => provider.WeatherProvider()),
            ChangeNotifierProvider(create: (context) => provider.AlertData()),
            ChangeNotifierProvider(create: (_) => provider.ConfigData()),
            ChangeNotifierProvider(
                create: (context) =>
                    provider.AwsIotProvider(clientId: "FixedClientID5569")),
            ChangeNotifierProvider(
                create: (_) => provider.ButtonWeatherProvider()),
          ],
          child: MaterialApp.router(
            routerConfig: _router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('vi'), // Vietnamese
            ],
          ));
}
