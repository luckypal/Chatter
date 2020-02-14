import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/conversation.dart/base.dart';
import 'package:chatter/src/models/conversation.dart/chatter.dart';
import 'package:chatter/src/models/message/base.dart';
import 'package:chatter/src/models/message/chatter.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/services/conversation/base.dart';
import 'package:chatter/src/services/conversation/multi.dart';
import 'package:chatter/src/services/user/chatter.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationStatus {
  static const int WAITING_ACCEPT = 0;
  static const int ACCEPTED = 1;
  static const int BLOCKED = 2;
  static const int DELETED = 3;
}

/**
 * conversationHeaders: Object {
 *  userId: Object {
 *    conversationId: {
 *      status: false,
 *      unread: 0,
 *      ...
 *    }
 *  }
 * }
 * 
 * conversations: Object {
 *  conversationId: {
 *    users: [userId1, userId2, ...],
 *    createdAt: *****
 *  }
 * }
 */
abstract class ChatterConversationService extends BaseConversationService
    with ChangeNotifier {
  static const String COLLECTION_HEADER_NAME = "conversationHeaders";
  static const String COLLECTION_NAME = "conversations";

  OwnerUserService ownerUserService;
  MultiConversationService multiConversationService;

  final Firestore firestore = Firestore.instance;
  List<ChatterConversationModel> get models => super.models;

  ChatterConversationService();

  void init() {
    ownerUserService = locator<OwnerUserService>();
    multiConversationService = locator<MultiConversationService>();
  }

  void load();
}

class ChatterConversationServiceImpl extends ChatterConversationService {
  @override
  void load() async {
    String userIdentifier = ownerUserService.model.identifier;

    Stream<QuerySnapshot> queryStream = firestore
        .collection(
            '${ChatterConversationService.COLLECTION_HEADER_NAME}/$userIdentifier')
        .snapshots();
    queryStream.listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> list = snapshot.documents;
      updateModel(list);

      multiConversationService.onUpdate(ChatPlatform.chatter);
    });
  }

  updateModel(List<DocumentSnapshot> list) {
    List<ChatterConversationModel> temp = new List<ChatterConversationModel>();
    list.forEach((DocumentSnapshot item) {
      // temp.add(ChatterConversationModel.fromDocument(item));
    });
  }

  @override
  Future<MessageModel> sendMessageModel(MessageModel msg) {
    return new Future<MessageModel>(() async {
      ChatterMessageModel messageModel = msg;
      messageModel.save();

      return messageModel;
    });
  }

  CollectionReference getHeaderCollection(String userIdentifier) {
    return firestore
        .collection(ChatterUserService.COLLECTION_NAME)
        .document(userIdentifier)
        .collection(ChatterConversationService.COLLECTION_HEADER_NAME);
  }

  @override
  Future<ConversationModel> createConversation(String title, List<UserModel> receivers, int platform) {
    return new Future<ConversationModel>(() async {
      String userIdentifier = ownerUserService.model.identifier;
      List<String> userIds = new List<String>();
      userIds.add(userIdentifier);

      DocumentReference mineRef = await getHeaderCollection(userIdentifier)
          .add({"status": ConversationStatus.ACCEPTED, "unread": 0});
      String conversationId = mineRef.documentID;

      receivers.forEach((user) {
        String identifier = user.identifier;
        userIds.add(identifier);
        getHeaderCollection(identifier).document(conversationId).setData(
            {"status": ConversationStatus.WAITING_ACCEPT, "unread": 1});
      });

      int createdTime = DateTime.now().millisecondsSinceEpoch;
      ConversationModel conversationModel = ChatterConversationModel.create(conversationId, title, userIds, createdTime);
      conversationModel.save();

      return conversationModel;
    });
  }
}
