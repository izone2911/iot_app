import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/_index.dart' as provider;

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.id, required this.partner});

  final String id;
  final provider.PartnerModel partner;

  @override
  Widget build(BuildContext context) {
    List<provider.MessageModel> messages = [];
    final _ = context.select((provider.MessProvider p) {
      messages = p.getConversationByID(id).messages;
      return messages.length;
    });

    final messProvider =
        Provider.of<provider.MessProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Messenger'),
        ),
        body: Column(
            children: messages
                .map((message) => Row(children: [
                      Text(message.isUserMess ? "user:" : "partner:"),
                      Text(message.message),
                      const Spacer(),
                      message.isUserMess
                          ? ElevatedButton(
                              onPressed: () {
                                messProvider.deleteMessagenPost(
                                  messageID: message.id,
                                  conversationID: id,
                                );
                              },
                              child: const Text("delete"))
                          : const SizedBox(),
                    ]))
                .toList()));
  }
}
