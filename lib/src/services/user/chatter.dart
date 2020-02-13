import 'package:chatter/src/services/user/base.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/models/user/chatter.dart';

abstract class ChatterUserService extends BaseUserService {
  final Firestore firestore = Firestore.instance;

  ChatterUserService();
}

class ChatterUserServiceImpl extends ChatterUserService {
  @override
  Future<List<UserModel>> load() {
    return null;
  }

  @override
  Future<List<ChatterUserModel>> findUsersByPhoneNumber({List<String> phoneNumbers}) {
    return new Future<List<ChatterUserModel>>(() async {
      List<ChatterUserModel> users = new List<ChatterUserModel>();
      QuerySnapshot query = await firestore
          .collection('users')
          .where("phoneNumber", whereIn: phoneNumbers)
          .getDocuments();
      query.documents.forEach((doc) {
        users.add(new ChatterUserModel(doc: doc));
      });

      return users;
    });
  }
}
