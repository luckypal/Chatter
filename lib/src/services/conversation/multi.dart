import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/message/base.dart';
import 'package:chatter/src/models/message/chatter.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/services/conversation/base.dart';
import 'package:chatter/src/services/conversation/chatter.dart';
import 'package:chatter/src/services/user/multi.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:flutter/material.dart';

abstract class MultiConversationService extends BaseConversationService
    with ChangeNotifier {
  OwnerUserService ownerUserService;
  MultiUserService multiUserService;
  
  ChatterConversationService chatterConversationService;

  int get length => 0;
  bool get isEmpty => length == 0;
  bool get isNotEmpty => length != 0;

  MultiConversationService();

  ConversationModel modelAt(int index);
  void onUpdate(int platform);
  Function onEvent(int platform) => () => onUpdate(platform);

  Future<MessageModel> sendMessage(
      ConversationModel conversationModel, String message, int messageType);
}

class MultiConversationServiceImpl extends MultiConversationService {
  int get length {
    return chatterConversationService.models != null ? chatterConversationService.models.length : 0;
  }

  MultiConversationServiceImpl() {
    multiUserService = locator<MultiUserService>();
    chatterConversationService = locator<ChatterConversationService>();
    chatterConversationService.addListener(onEvent(ChatPlatform.chatter));

    ownerUserService = locator<OwnerUserService>();
  }

  ConversationModel modelAt(int index) {
    return chatterConversationService.models [index];
  }

  @override
  void onUpdate(int platform) {
    notifyListeners();
  }

  @override
  Future<MessageModel> sendMessage(
      ConversationModel conversationModel, String message, int messageType) {
    switch (conversationModel.platform) {
      case ChatPlatform.chatter:
        ChatterMessageModel messageModel = ChatterMessageModel.create(
            platform: ChatPlatform.chatter,
            conversationId: conversationModel.identifier,
            senderId: ownerUserService.identifier,
            message: message,
            messageType: messageType);
        return sendMessageModel(messageModel);
        break;
    }
    return null;
  }

  @override
  Future<MessageModel> sendMessageModel(MessageModel messageModel) {
    switch (messageModel.platform) {
      case ChatPlatform.chatter:
        return chatterConversationService.sendMessageModel(messageModel);
    }

    return null;
  }

  @override
  Future<ConversationModel> createConversation(String title, List<UserModel> receivers, int platform) {
    switch (platform) {
      case ChatPlatform.chatter:
        return chatterConversationService.createConversation(title, receivers, ChatPlatform.chatter);
    }
    return null;
  }

  @override
  void load() {
    multiUserService.load().then((_) {
      chatterConversationService.load();
    });
  }

  @override
  StreamBuilder streamBuilder({GlobalKey<AnimatedListState> key, ConversationModel conversationModel}) {
    switch (conversationModel.platform) {
      case ChatPlatform.chatter:
        return chatterConversationService.streamBuilder(key: key, conversationModel: conversationModel);
    }
    return null;
  }

  @override
  ConversationModel findConversationModel(UserModel user) {
    switch (user.platform) {
      case ChatPlatform.chatter:
        return chatterConversationService.findConversationModel(user);
    }
    return null;
  }
}
