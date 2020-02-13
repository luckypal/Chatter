import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/conversation.dart/chatter.dart';
import 'package:chatter/src/models/message/base.dart';
import 'package:chatter/src/models/message/chatter.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/services/conversation/base.dart';
import 'package:chatter/src/services/conversation/multi.dart';
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

      multiConversationService.onUpdate(UserPlatform.chatter);
    });
  }

  updateModel(List<DocumentSnapshot> list) {
    List<ChatterConversationModel> temp = new List<ChatterConversationModel>();
    list.forEach((DocumentSnapshot item) {
      temp.add(ChatterConversationModel.fromDocument(item));
    });
  }

  @override
  Future<String> sendMessageModel(MessageModel msg, List<UserModel> receivers) {
    return new Future<void>(() async {
      ChatterMessageModel messageModel = msg;
      // ChatterConversationModel chatterConvModel;

      // if (messageModel.conversationId == null) {
      //   models.forEach((ChatterConversationModel item) {
      //     if (chatterConvModel != null) return;
      //     if (item.identifier == messageModel.conversationId)
      //       chatterConvModel = item;
      //   });
      // }

      String conversationId = messageModel.conversationId;
      if (conversationId == null) {
        //Add Conversation to firebase conversation collection
        conversationId = await create(receivers, messageModel);
        messageModel.conversationId = conversationId;
      } else {
        //Process conversation item of database
        conversationId = messageModel.conversationId;
      }

      await messageModel.save();
    });
  }

  @override
  Future<String> create(List<UserModel> receivers, MessageModel msg) {
    return new Future<String>(() async {
      String userIdentifier = ownerUserService.model.identifier;
      ChatterMessageModel messageModel = msg;
      String conversationId = messageModel.conversationId;
      List<String> users = new List<String>();
      users.add(userIdentifier);

      if (conversationId == null) {
        DocumentReference mineRef = await firestore
          .collection("${ChatterConversationService.COLLECTION_HEADER_NAME}/$userIdentifier")
          .add({
            "status": ConversationStatus.ACCEPTED,
            "unread": 0
        });
        conversationId = mineRef.documentID;
        messageModel.conversationId = conversationId;

        receivers.forEach((user) {
          String identifier = user.identifier;
          users.add(identifier);
          firestore
            .collection("${ChatterConversationService.COLLECTION_HEADER_NAME}/$identifier")
            .document(conversationId)
            .setData({
              "status": ConversationStatus.WAITING_ACCEPT,
              "unread": 1
          });
        });
      }

      firestore
          .collection("${ChatterConversationService.COLLECTION_NAME}")
          .document(conversationId)
          .setData({
        "users": users,
        "createdAt": DateTime.now().millisecondsSinceEpoch
      });

      return conversationId;
    });
  }
}
