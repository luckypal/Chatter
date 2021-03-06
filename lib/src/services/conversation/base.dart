import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/message/base.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:flutter/material.dart';

abstract class BaseConversationService {
  BaseConversationService();

  List<ConversationModel> _models;
  get models => _models;
  set models(List<ConversationModel> value) => _models = value;

  Future<ConversationModel> createConversation(String title, List<UserModel> receivers, int platform);
  Future<MessageModel> sendMessageModel(MessageModel msg);
  void load();
  StreamBuilder streamBuilder({GlobalKey<AnimatedListState> key, ConversationModel conversationModel});

  ConversationModel findConversationModel(UserModel user);
}
