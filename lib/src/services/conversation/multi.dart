import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/message/base.dart';
import 'package:chatter/src/models/message/chatter.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/services/conversation/base.dart';
import 'package:chatter/src/services/conversation/chatter.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:flutter/material.dart';

abstract class MultiConversationService extends BaseConversationService
    with ChangeNotifier {
  OwnerUserService ownerUserService;
  ChatterConversationService chatterConversationService;

  MultiConversationService() {
    chatterConversationService = locator<ChatterConversationService>();
    chatterConversationService.addListener(onEvent(ChatPlatform.chatter));

    ownerUserService = locator<OwnerUserService>();
  }

  int get length => 0;

  Function onEvent(int platform) => () => onUpdate(platform);

  void onUpdate(int platform);

  Future<MessageModel> sendMessage(
      ConversationModel conversationModel, String message, int messageType);
}

class MultiConversationServiceImpl extends MultiConversationService {
  int get length => chatterConversationService.models.length;

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
            ChatPlatform.chatter,
            conversationModel.identifier,
            ownerUserService.model.identifier,
            message,
            messageType);
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
}
