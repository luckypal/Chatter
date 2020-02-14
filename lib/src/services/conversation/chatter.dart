import 'dart:async';

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
  OwnerUserService ownerUserService;
  MultiConversationService multiConversationService;

  final Firestore firestore = Firestore.instance;
  List<ChatterConversationModel> get models => super.models;

  ChatterConversationService();

  void init() {
    ownerUserService = locator<OwnerUserService>();
    multiConversationService = locator<MultiConversationService>();
  }
}

class ChatterConversationServiceImpl extends ChatterConversationService {

  updateModel(List<DocumentSnapshot> list) {
    List<ChatterConversationModel> temp = new List<ChatterConversationModel>();
    list.forEach((DocumentSnapshot item) {
      // temp.add(ChatterConversationModel.fromDocument(item));
    });
  }

  // DocumentReference getCollection(String conversationId) {
  //   return firestore
  //       .collection(ChatterConversationModel.COLLECTION_NAME)
  //       .document(conversationId);
  // }

  @override
  Future<MessageModel> sendMessageModel(MessageModel msg) {
    return new Future<MessageModel>(() async {
      ChatterMessageModel messageModel = msg;
      messageModel.save();

      return messageModel;
    });
  }

  @override
  Future<ConversationModel> createConversation(
      String title, List<UserModel> receivers, int platform) {
    return new Future<ConversationModel>(() async {
      String userIdentifier = ownerUserService.identifier;
      List<String> userIds = new List<String>();
      userIds.add(userIdentifier);

      ChatterConversationHeaderModel headerModel = ChatterConversationHeaderModel.create(
          userIdentifier: userIdentifier,
          conversationId: null,
          status: ConversationStatus.ACCEPTED,
          unreadMessageCount: 0);
      headerModel.save();

      String conversationId = headerModel.conversationId;

      receivers.forEach((user) {
        String identifier = user.identifier;
        userIds.add(identifier);
        
        ChatterConversationHeaderModel otherHeaderModel = ChatterConversationHeaderModel.create(
            userIdentifier: userIdentifier,
            conversationId: conversationId,
            status: ConversationStatus.WAITING_ACCEPT,
            unreadMessageCount: 0);
        otherHeaderModel.save();
      });

      int createdTime = DateTime.now().millisecondsSinceEpoch;
      ConversationModel conversationModel = ChatterConversationModel.create(
          conversationId, title, userIds, createdTime);
      conversationModel.save();

      return conversationModel;
    });
  }

  @override
  void load() {
    String userIdentifier = ownerUserService.identifier;
    models = new List<ChatterConversationModel>();

    ChatterConversationHeaderModel.getCollection(userIdentifier)
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      models.clear();

      List<DocumentSnapshot> list = snapshot.documents;
      for (int index = 0; index < list.length; index ++) {
        DocumentSnapshot headerDoc = list [index];
        String conversationId = headerDoc.documentID;

        ChatterConversationHeaderModel headerModel = await ChatterConversationHeaderModel.loadFromConversationId(userIdentifier, conversationId);
        ChatterConversationModel conversationModel = await ChatterConversationModel.loadFromConversationId(conversationId: conversationId);
        conversationModel.headerModel = headerModel;

        models.add(conversationModel);
      }

      multiConversationService.onUpdate(ChatPlatform.chatter);
    });
  }
}
