import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/services/conversation/chatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatterConversationModel extends ConversationModel {
  String _title;
  String get title => _title;

  final Firestore firestore = Firestore.instance;

  ChatterConversationModel();

  ChatterConversationModel.create(
      String identifier, String title, List<String> users, int createdTime)
      : super.create(
            identifier, title, users, ChatPlatform.chatter, createdTime);

  /*static ChatterConversationModel fromDocument(DocumentSnapshot item) {
    ChatterConversationModel model = ChatterConversationModel();
    model.loadFromDoc(item);
    return model;
  }
  
  void loadFromDoc(DocumentSnapshot item) {

  }*/

  @override
  void save() {
    firestore
        .collection(ChatterConversationService.COLLECTION_NAME)
        .document(identifier)
        .setData({
      "title": title,
      "userIds": userIds,
      "createdAt": createdTime
    });
  }
}
