import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatterConversationModel extends ConversationModel {
  String _title;
  String get title => _title;

  ChatterConversationModel();

  static ChatterConversationModel fromDocument(DocumentSnapshot item) {
    ChatterConversationModel model = ChatterConversationModel();
    model.loadFromDoc(item);
    return model;
  }
  
  void loadFromDoc(DocumentSnapshot item) {

  }
}