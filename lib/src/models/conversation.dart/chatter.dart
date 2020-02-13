import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:contacts_service/contacts_service.dart';

class ChatterConversationModel extends ConversationModel {
  String _title;
  String get title => _title;

  ChatterConversationModel();

  // static ChatterConversationModel createConversation({String title, List<UserModel> users}) {
  //   ChatterConversationModel model = new ChatterConversationModel();

  //   return model;
  // }
}