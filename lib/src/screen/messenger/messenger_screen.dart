import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../provider/_index.dart' as provider;
import 'conversation_widget.dart';

class MessengerScreen extends StatelessWidget {
  const MessengerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isListConversationChanged = context
        .select((provider.MessProvider p) => p.isListConversationChanged);
    final messProvider =
        Provider.of<provider.MessProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Messenger'),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          messProvider.sendMessage(
            message: Random().nextInt(10000).toString(),
            receiverID: '379',
          );
        },
        child: const Text("Fake Send"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: isListConversationChanged ? 30 : 40),
            Column(
              children: messProvider.listConversation
                  .map((conversation) => Container(
                      height: 50,
                      margin: const EdgeInsetsDirectional.only(bottom: 20),
                      child: ConversationWidget(converation: conversation)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
