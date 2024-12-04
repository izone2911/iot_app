import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/_index.dart' show Assets;
import '../network/network_handler.dart';

class NetworkWidget<T extends NetworkHandler> extends StatelessWidget {
  const NetworkWidget({super.key, required this.child, required this.onReload});

  final Widget child;
  final void Function() onReload;

  @override
  Widget build(BuildContext context) {
    final requestCode = context.select<T, RequestCode>(/**/
        (provider) => provider.requestCode);

    final width = MediaQuery.sizeOf(context).width;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: (requestCode != RequestCode.timeout &&
              requestCode != RequestCode.notConnect)
          ? child
          : Scaffold(
              key: Key(requestCode.name),
              body: Center(child: errorWidget(width, requestCode))),
    );
  }

  // WIDGET
  Widget errorWidget(double width, RequestCode requestCode) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, /**/
          children: [
        const SizedBox(height: 15),
        requestCode == RequestCode.timeout
            ? somethingWrongImage(width * 0.8)
            : noConnectionImage(width * 0.6),
        /**/
        const SizedBox(height: 15),
        Text(
            requestCode == RequestCode.timeout
                ? "An Error Occurred!"
                : "No Internet!",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        /**/
        const SizedBox(height: 100),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white.withOpacity(0.9),
              backgroundColor: Colors.red.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0))),
          onPressed: () => onReload(),
          child: const Text("Reload Page", style: TextStyle(fontSize: 17)),
        )
      ]);

  // IMAGE
  Widget somethingWrongImage(width) => Container(
      width: width,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 254, 247, 255),
      ),
      child: const Image(image: Assets.somethingWrong));

  Widget noConnectionImage(width) {
    const color = Color.fromARGB(255, 254, 247, 255);

    return Container(
      width: width,
      decoration: const BoxDecoration(color: color),
      child: Stack(alignment: AlignmentDirectional.topEnd, /**/
          children: [
        const Image(image: Assets.noConnection),
        Container(width: width * 0.25, height: width * 0.10, color: color)
      ]),
    );
  }
}
