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
      name: constant.RoutePath.splash.name,
      path: constant.RoutePath.splash.relative,
      builder: (_, __) => const screen.SplashScreen(),
    ),
    GoRoute(
      name: constant.RoutePath.login.name,
      path: constant.RoutePath.login.relative,
      builder: (_, __) => const screen.LoginScreen(),
    ),
    GoRoute(
      name: constant.RoutePath.register.name,
      path: constant.RoutePath.register.relative,
      builder: (_, __) => screen.RegisterScreen(),
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
        StatefulShellBranch(
          routes: [
            GoRoute(
              // NOTIFICATION
              name: constant.RoutePath.alert.name,
              path: constant.RoutePath.alert.relative,
              builder: (_, __) => const screen.AlertScreen(),
              routes: [
                GoRoute(
                  // NOTIFICATION
                  name: constant.RoutePath.alertDetail.name,
                  path: constant.RoutePath.alertDetail.relative,
                  builder: (_, state) => screen.AlertDetailScreen(
                      alertModel: state.extra as provider.AlertModel),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(routes: [
          GoRoute(
              name: constant.RoutePath.assignment.name,
              path: constant.RoutePath.assignment.relative,
              builder: (_, __) => screen.ClassScreen())
        ]),
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       name: constant.RoutePath.messenger.name,
        //       path: constant.RoutePath.messenger.relative,
        //       builder: (_, __) => Container(),
        //       routes: [
        //         GoRoute(
        //             name: constant.RoutePath.chat.name,
        //             path: constant.RoutePath.chat.relative,
        //             builder: (_, state) => screen.ChatScreen(
        //                   id: state.pathParameters['id'] ?? '',
        //                   partner: state.extra as provider.PartnerModel,
        //                 ))
        //       ],
        //     ),
        //   ],
        // ),
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => provider.AuthProvider()),
            ChangeNotifierProvider(create: (_) => provider.AlertProvider()),
            ChangeNotifierProvider(create: (_) => provider.ClassProvider()),
            ChangeNotifierProvider(
                create: (_) => provider.AssignmentProvider()),
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
