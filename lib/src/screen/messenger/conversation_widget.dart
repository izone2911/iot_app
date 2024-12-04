import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/_index.dart' as provider;
import '../../constant/_index.dart' as constant;

class ConversationWidget extends StatelessWidget {
  const ConversationWidget({super.key, required this.converation});

  final provider.ConverationModel converation;

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime =
        DateTime.parse(converation.messages.first.created);
    final messProvider =
        Provider.of<provider.MessProvider>(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        messProvider.getConversationPost(converation.id);
        context.go(
          '${constant.RoutePath.chat.absolute}${converation.id}',
          extra: converation.partner,
        );
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.only(
          left: 10,
          right: 10,
        )),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                side: BorderSide(color: Colors.black))),
      ),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(20),
              child: const Image(
                image: AssetImage("assets/images/meme.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(converation.partner.username),
              Text(converation.messages.first.message)
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsetsDirectional.only(bottom: 20),
            child: Text(
                style:
                    const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                '${dateTime.day}/${dateTime.month}'),
          ),
        ],
      ),
    );
  }
}
