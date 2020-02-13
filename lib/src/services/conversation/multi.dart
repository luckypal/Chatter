import 'package:chatter/service_locator.dart';
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
    chatterConversationService.addListener(onEvent(UserPlatform.chatter));

    ownerUserService = locator<OwnerUserService>();
  }

  int get length => 0;

  Function onEvent(int platform) => () => onUpdate(platform);

  void onUpdate(int platform);

  Future<String> sendMessage(int platform, String conversationId,
      List<UserModel> receivers, String message, int messageType);
}

class MultiConversationServiceImpl extends MultiConversationService {
  int get length => chatterConversationService.models.length;

  @override
  void onUpdate(int platform) {
    notifyListeners();
  }

  @override
  Future<String> sendMessage(int platform, String conversationId,
      List<UserModel> receivers, String message, int messageType) {
    switch (platform) {
      case UserPlatform.chatter:
        ChatterMessageModel messageModel = ChatterMessageModel.create(
            platform,
            conversationId,
            ownerUserService.model.identifier,
            message,
            messageType);
        return sendMessageModel(messageModel, receivers);
        break;
    }
    return null;
  }

  @override
  Future<String> sendMessageModel(
      MessageModel messageModel, List<UserModel> receivers) {
    switch (messageModel.platform) {
      case UserPlatform.chatter:
        return chatterConversationService.sendMessageModel(
            messageModel, receivers);
        break;
    }

    return null;
  }

  @override
  Future<String> create(List<UserModel> receivers, MessageModel msg) =>
      null; //Not Used
}
