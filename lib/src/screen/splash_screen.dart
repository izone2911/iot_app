import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constant/_index.dart' as constant;
import '../provider/_index.dart' as provider;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final authProvider =
        Provider.of<provider.AuthProvider>(context, listen: false);
    checkLogin(authProvider);
  }

  checkLogin(provider.AuthProvider authProvider) async {
    if (context.mounted) {
      // ignore: use_build_context_synchronously
      context.go(await authProvider.checkLogin()
          ? constant.RoutePath.home.absolute
          : constant.RoutePath.login.absolute);
    }
  }

  final loadingAnimation = LoadingAnimationWidget.inkDrop(
    color: const Color(0xFF1A1A3F),
    size: 50,
  );

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Center(
        child: Column(children: [
          Expanded(
            child: Center(
              child: Image(
                image: constant.Assets.hustLogo,
                width: 0.2 * width,
              ),
            ),
          ),
          loadingAnimation,
          SizedBox(height: height * 0.1),
        ]),
      ),
    );
  }
}
