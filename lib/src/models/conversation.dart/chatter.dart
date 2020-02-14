import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/models/user/chatter.dart';
import 'package:chatter/src/services/conversation/chatter.dart';
import 'package:chatter/src/services/user/chatter.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationStatus {
  static const int WAITING_ACCEPT = 0;
  static const int ACCEPTED = 1;
  static const int CREATED = 2;
  static const int BLOCKED = 3;
  static const int DELETED = -1;
}

class ChatterConversationHeaderModel {
  static const String COLLECTION_NAME = "conversationHeaders";

  String _userIdentifier;
  String get userIdentifier => _userIdentifier;
  // set userIdentifier(value) => _userIdentifier = value;

  String _conversationId;
  String get conversationId => _conversationId;
  // set conversationId(value) => _conversationId = value;

  int _status; //ConversationStatus
  int get status => _status;

  int _unreadMessageCount;
  int get unreadMessageCount => _unreadMessageCount;

  ChatterConversationHeaderModel();

  ChatterConversationHeaderModel.create(
      {String userIdentifier,
      String conversationId,
      int status,
      int unreadMessageCount})
      : _userIdentifier = userIdentifier,
        _conversationId = conversationId,
        _status = status,
        _unreadMessageCount = unreadMessageCount;

  static CollectionReference getCollection(String userIdentifier) {
    return Firestore.instance
        .collection(ChatterUserService.COLLECTION_NAME)
        .document(userIdentifier)
        .collection(ChatterConversationHeaderModel.COLLECTION_NAME);
  }

  Future<void> save() {
    return new Future<void>(() async {
      if (_conversationId == null) {
        DocumentReference ref =
            await ChatterConversationHeaderModel.getCollection(userIdentifier)
                .add({
          "status": ConversationStatus.CREATED,
          "unreadMessageCount": 0
        });
        _conversationId = ref.documentID;
      } else
        ChatterConversationHeaderModel.getCollection(userIdentifier)
            .document(_conversationId)
            .setData({
          "status": ConversationStatus.WAITING_ACCEPT,
          "unreadMessageCount": 0
        });
    });
  }
}

class ChatterConversationModel extends ConversationModel {
  static const String COLLECTION_NAME = "conversations";

  String _title;
  String get title => _title;

  final Firestore firestore = Firestore.instance;

  ChatterConversationModel();

  ChatterConversationModel.create(
      String identifier, String title, List<String> users, int createdTime)
      : super.create(
            identifier, title, users, ChatPlatform.chatter, createdTime);

  static DocumentReference getDocument(String conversationId) {
    return Firestore.instance
        .collection(ChatterConversationModel.COLLECTION_NAME)
        .document(conversationId);
  }

  static Future<ChatterConversationModel> loadFromConversationId(
      {String conversationId}) {
    return new Future<ChatterConversationModel>(() async {
      Map<String, dynamic> data = (await getDocument(conversationId).get()).data;
      List<String> userIds = new List<String>();
      data["userIds"].forEach((userId) {
        userIds.add(userId);
      });
      // userIds.addAll(data["userIds"]);

      ChatterConversationModel conversationModel = ChatterConversationModel.create(
        conversationId,
        data["title"],
        userIds,
        data["createdTime"]
      );

      if (conversationModel.userIds.length == 2) { //One-to-one chat
        OwnerUserService ownerUserService = locator<OwnerUserService>();
        int otherUserIndex = conversationModel.userIds [0] == ownerUserService.identifier ? 1 : 0;
        String otherUserId = conversationModel.userIds [otherUserIndex];

        ChatterUserService userService = locator<ChatterUserService>();
        ChatterUserModel otherUserModel = await userService.findUserByIdentifier(otherUserId);

        conversationModel.photoUrl = otherUserModel.photoUrl;
        conversationModel.userModel = new List<ChatterUserModel>();
        conversationModel.userModel.add(otherUserModel);
      }

      return conversationModel;
    });
  }
  /*static ChatterConversationModel fromDocument(DocumentSnapshot item) {
    ChatterConversationModel model = ChatterConversationModel();
    model.loadFromDoc(item);
    return model;
  }
  
  void loadFromDoc(DocumentSnapshot item) {

  }*/

  @override
  void save() {
    ChatterConversationModel.getDocument(identifier).setData(
        {"title": title, "userIds": userIds, "createdAt": createdTime});
  }
}
