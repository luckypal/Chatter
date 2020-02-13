import 'package:chatter/src/models/message/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatterMessageModel extends MessageModel {
  static const String COLLECTION_NAME = "messages";

  final Firestore firestore = Firestore.instance;

  ChatterMessageModel();

  ChatterMessageModel.create(int platform, String conversationId, String ownerId, String message, int messageType)
      : super.create(null, conversationId, ownerId, platform, message, messageType, DateTime.now().millisecondsSinceEpoch);

  void loadFromDoc(DocumentSnapshot item) {}

  @override
  Future<String> save() {
    return new Future<String>(() async {
      DocumentReference msgRef = await firestore
          .collection("${ChatterMessageModel.COLLECTION_NAME}/$conversationId")
          .add({
        "sender": senderId,
        "message": message,
        "messageType": messageType,
        "sentTime": sentTime
      });

      return msgRef.documentID;
    });
  }
}
