import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:convert';

import '../constant/_index.dart' as constant;
import 'global_provider.dart';

// EXTENSION--------------------------
extension MessSocket on MessProvider {
  void _initStompClient() {
    _stompClient = StompClient(
        config: StompConfig.sockJS(
            url: constant.Urls.websocket,
            onConnect: _onConnect,
            onWebSocketError: (error) {
              _stompClient?.deactivate();
              _stompClient = null;
              debugPrint(error.toString());
            }));

    _stompClient?.activate();
  }

  void _onConnect(StompFrame frame) {
    _isStompConnected = true;

    _stompClient?.subscribe(
      destination: '/user/${GlobalProvider.userID}/inbox',
      callback: (frame) => _updateConversation(json.decode(frame.body!)),
    );
  }

  void sendMessage({required String message, required String receiverID}) {
    final Map<String, Object> data = {
      "receiver": {"id": receiverID},
      "content": message,
      // "sender": GlobalProvider.email,
      // "token": GlobalProvider.token
      "sender": 'userA@hust.edu.vn',
      "token": 'EOwfEA'
    };

    if (_isStompConnected) {
      _stompClient?.send(
        destination: "/chat/message",
        body: json.encode(data),
      );
    }
  }
}

extension MessConverter on MessProvider {
  Map<String, dynamic> _convertMessagePost(dynamic data) => <String, dynamic>{
        'id': data['message_id'].toString(),
        'message': data['message'] as String,
        'created': data['created_at'] as String,
        'unread': data['unread'].toString(),
        'isUserMess': data['sender']['id'].toString() == GlobalProvider.userID,
      };

  Map<String, dynamic> _convertMessageSocket(dynamic data) => <String, dynamic>{
        'id': data['id'].toString(),
        'message': data['content'] as String,
        'created': data['created_at'] as String,
        'unread': data['sender']['id'].toString() == GlobalProvider.userID
            ? '0'
            : '1',
        'isUserMess': data['sender']['id'].toString() == GlobalProvider.userID,
      };

  Map<String, dynamic> _convertConversationSocket(dynamic data) =>
      <String, dynamic>{
        'id': data['conversation_id:'].toString(),
        'partner': <String, dynamic>{
          'id': data['sender']['id'].toString(),
          'username': data['sender']['name'] as String,
          'avatar': data['sender']['avatar'] as String,
        },
        'messages': <Map<String, dynamic>>[
          _convertMessageSocket(data),
        ],
      };

  Map<String, dynamic> _convertListConversation(dynamic data) =>
      <String, dynamic>{
        'id': data['id'].toString(),
        'partner': <String, dynamic>{
          'id': data['partner']['id'].toString(),
          'username': data['partner']['name'] as String,
          'avatar': data['partner']['avatar'] as String,
        },
        'messages': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'last',
            'message': data['last_message']['message'] as String,
            'created': data['last_message']['created_at'] as String,
            'unread': data['last_message']['unread'].toString(),
            'isUserMess':
                data['last_message']['sender']['id'] == GlobalProvider.userID,
          },
        ],
      };
}

// PROVIDER-----------------------------
class MessProvider with ChangeNotifier {
  MessProvider() {
    _initStompClient();
    getListConversationPost();
  }

  StompClient? _stompClient;
  bool _isStompConnected = false;

  final String _index = "0";
  final String _count = "3";

  bool isListConversationChanged = false;
  final List<String> listConversationID = [];
  final List<ConverationModel> listConversation = [];

  ConverationModel getConversationByID(String id) => listConversation[
      listConversation.indexWhere((conversation) => conversation.id == id)];

  void _updateConversation(dynamic data) {
    var conversation = listConversation
        .where((element) => element.id == data['conversation_id'].toString())
        .toList();

    if (conversation.isEmpty) {
      listConversation.insert(
          0, ConverationModel.fromJson(_convertConversationSocket(data)));
      listConversationID.add(data['conversation_id'].toString());
    } else {
      conversation[0]
          .messages
          .insert(0, MessageModel.fromJson(_convertMessageSocket(data)));
    }

    isListConversationChanged = !isListConversationChanged;
    notifyListeners();
  }

  void getConversationPost(String id) async {
    String token = GlobalProvider.token;

    if (token != '') {
      final Map<String, String> data = {
        "token": GlobalProvider.token,
        "index": _index.toString(),
        "count": _count.toString(),
        "conversation_id": id,
        "mark_as_read": "true"
      };

      final response = await http.post(
        Uri.parse(constant.Urls.getConversation),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        List<dynamic> messages = body['data']['conversation'];
        ConverationModel conversation = getConversationByID(id);

        conversation.messages.clear(); // debugOnly

        for (var message in messages) {
          conversation.messages
              .insert(0, MessageModel.fromJson(_convertMessagePost(message)));
        }
      }
    }

    isListConversationChanged = !isListConversationChanged;
    notifyListeners();
  }

  void getListConversationPost() async {
    String token = GlobalProvider.token;

    if (token != '') {
      final Map<String, String> data = {
        "token": token,
        "index": _index,
        "count": _count
      };

      final response = await http.post(
        Uri.parse(constant.Urls.getListConversation),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        List<dynamic> conversations = body['data']['conversations'];

        for (var conversation in conversations) {
          listConversation.add(ConverationModel.fromJson(
              _convertListConversation(conversation)));
          listConversationID.add(conversation['id'].toString());
        }
      }
    }

    isListConversationChanged = !isListConversationChanged;
    notifyListeners();
  }

  void deleteMessagenPost(
      {required String messageID, required String conversationID}) async {
    String token = GlobalProvider.token;

    if (token != '') {
      final Map<String, String> data = {
        "token": GlobalProvider.token,
        "message_id": messageID,
        "conversation_id": conversationID
      };

      final response = await http.post(
        Uri.parse(constant.Urls.deleteMessage),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      debugPrint(response.body);
    }
  }
}

// MODEL----------------
class ConverationModel {
  final String id;
  final PartnerModel partner;
  final List<MessageModel> messages;

  ConverationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        partner = PartnerModel.fromJson(json['partner']),
        messages = List<MessageModel>.from(json['messages'].map(
            (Map<String, dynamic> message) => MessageModel.fromJson(message)));
}

class PartnerModel {
  final String id, username, avatar;

  PartnerModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        avatar = json['avatar'];
}

class MessageModel {
  final String id, message, created, unread;
  final bool isUserMess;

  MessageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        message = json['message'],
        created = json['created'],
        unread = json['unread'],
        isUserMess = json['isUserMess'];
}
