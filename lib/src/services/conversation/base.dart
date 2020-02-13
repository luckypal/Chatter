import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/message/base.dart';
import 'package:chatter/src/models/user/base.dart';

abstract class BaseConversationService {
  BaseConversationService();

  List<ConversationModel> _models;
  get models => _models;
  set models(List<ConversationModel> value) => _models = value;

  Future<String> create(List<UserModel> receivers, MessageModel msg);
  // Future<String> sendMessage(String message, String messageType);
  Future<String> sendMessageModel(MessageModel msg, List<UserModel> receivers);
}
