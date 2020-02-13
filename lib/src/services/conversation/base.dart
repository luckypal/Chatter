import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/user/base.dart';

abstract class BaseConversationService {
  BaseConversationService() {}

  List<ConversationModel> _models;
  get models => _models;
  set models(List<ConversationModel> value) => _models = value;
}
