import 'package:chatter/src/models/conversation.dart/chatter.dart';
import 'package:chatter/src/models/message/base.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/services/conversation/chatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatterMessageModel extends MessageModel {
  static const String COLLECTION_NAME = "messages";

  final Firestore firestore = Firestore.instance;

  ChatterMessageModel();

  ChatterMessageModel.create(
      {String messageId,
      @required int platform,
      @required String conversationId,
      @required String senderId,
      @required String message,
      @required int messageType,
      int sentTime = 0})
      : super.create(messageId, conversationId, senderId, platform, message,
            messageType, sentTime);

  static ChatterMessageModel createFromDocument(
      DocumentSnapshot item, String conversationId) {
    Map<String, dynamic> data = item.data;
    return ChatterMessageModel.create(
        messageId: item.documentID,
        platform: ChatPlatform.chatter,
        conversationId: conversationId,
        senderId: data["sender"],
        message: data["message"],
        messageType: data["messageType"],
        sentTime: data["sentTime"]);
  }

  static CollectionReference getMessageCollection(String conversationId) {
    return Firestore.instance
        .collection(ChatterConversationModel.COLLECTION_NAME)
        .document(conversationId)
        .collection(ChatterMessageModel.COLLECTION_NAME);
  }

  @override
  Future<String> save() {
    return new Future<String>(() async {
      DocumentReference msgRef =
          await ChatterMessageModel.getMessageCollection(conversationId).add({
        "sender": senderId,
        "message": message,
        "messageType": messageType,
        "sentTime": sentTime
      });

      return msgRef.documentID;
    });
  }
}
