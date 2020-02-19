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
/*
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

  static Future<ChatterConversationHeaderModel> loadFromConversationId(String userIdentifier, String conversationId) {
    return new Future<ChatterConversationHeaderModel>(() async {
      DocumentSnapshot doc = await getCollection(userIdentifier).document(conversationId).get();

      return ChatterConversationHeaderModel.create(
        userIdentifier: userIdentifier,
        conversationId: conversationId,
        status: doc.data ["status"],
        unreadMessageCount: doc.data ["unreadMessageCount"]
      );
    });
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
}*/

class ChatterConversationModel extends ConversationModel {
  static const String COLLECTION_NAME = "conversations";

  // ChatterConversationHeaderModel headerModel;

  final Firestore firestore = Firestore.instance;

  ChatterConversationModel();

  int get unreadMessageCount => 0;

  bool get hasUnreadMessage => unreadMessageCount != 0;

  String get title => (userIds.length == 2 && userModel != null) ? userModel[0].userName : super.title;

  bool get hasLastMessage => true;
  String get lastMessage => "This is last message.";

  ChatterConversationModel.create(
      String identifier, String title, List<String> users, int createdTime)
      : super.create(
            identifier, title, users, ChatPlatform.chatter, createdTime);

  static DocumentReference getDocument(String conversationId) {
    return Firestore.instance
        .collection(ChatterConversationModel.COLLECTION_NAME)
        .document(conversationId);
  }

  static ChatterConversationModel createFromDocument(
      DocumentSnapshot document) {
    List<String> userIds = [];
    document.data["userIds"].forEach((userId) => userIds.add(userId));
    return ChatterConversationModel.create(
        document.documentID,
        document.data["title"],
        userIds,
        document.data["createdTime"]);
  }

  static Future<ChatterConversationModel> loadFromConversationId(
      {String conversationId}) {
    return new Future<ChatterConversationModel>(() async {
      Map<String, dynamic> data =
          (await getDocument(conversationId).get()).data;
      List<String> userIds = new List<String>();
      data["userIds"].forEach((userId) {
        userIds.add(userId);
      });
      // userIds.addAll(data["userIds"]);

      ChatterConversationModel conversationModel =
          ChatterConversationModel.create(
              conversationId, data["title"], userIds, data["createdTime"]);

      await conversationModel.loadUsersForConversation();

      return conversationModel;
    });
  }

  @override
  Future<void> loadUsersForConversation() async {
    if (userIds.length == 2) {
      //One-to-one chat
      OwnerUserService ownerUserService = locator<OwnerUserService>();
      int otherUserIndex = userIds[0] == ownerUserService.identifier ? 1 : 0;
      String otherUserId = userIds[otherUserIndex];

      ChatterUserService userService = locator<ChatterUserService>();
      ChatterUserModel otherUserModel =
          await userService.findUserByIdentifier(otherUserId);

      photoUrl = otherUserModel.photoUrl;
      userModel = new List<ChatterUserModel>();
      userModel.add(otherUserModel);
    }
  }
  /*static ChatterConversationModel fromDocument(DocumentSnapshot item) {
    ChatterConversationModel model = ChatterConversationModel();
    model.loadFromDoc(item);
    return model;
  }
  
  void loadFromDoc(DocumentSnapshot item) {

  }*/

  @override
  Future<void> save() {
    return new Future<void>(() async {
      Map<String, dynamic> data = {
        "title": title,
        "userIds": userIds,
        "createdTime": createdTime
      };
      if (identifier == null) {
        DocumentReference ref = await firestore
            .collection(ChatterConversationModel.COLLECTION_NAME)
            .add(data);
        identifier = ref.documentID;
      } else {
        ChatterConversationModel.getDocument(identifier).setData(data);
      }
    });
  }
}
