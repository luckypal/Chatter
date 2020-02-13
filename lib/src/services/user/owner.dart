import 'package:chatter/src/services/user/base.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatter/src/models/user/base.dart';
import 'package:chatter/src/models/user/chatter.dart';
import 'package:flutter/services.dart';

abstract class OwnerUserService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  FirebaseUser _user;
  FirebaseUser get user => _user;

  ChatterUserModel _model;
  ChatterUserModel get model => _model;

  CountryCode countryCode;

  OwnerUserService();

  Future<FirebaseUser> load({bool isStrict = true});
  Future<void> update(UserUpdateInfo userUpdateInfo);
}

class OwnerUserServiceImpl extends OwnerUserService {
  @override
  Future<FirebaseUser> load({bool isStrict = true}) {
    return new Future(() async {
      _user = await firebaseAuth.currentUser();
      if (_user == null) return null;

      Firestore firestore = Firestore.instance;

      QuerySnapshot query = await firestore
          .collection('users')
          .where("phoneNumber", isEqualTo: _user.phoneNumber)
          .limit(1)
          .getDocuments();

      if (query.documents.length == 0) {
        if (isStrict) {
          try {
            await _user.delete();
          } on PlatformException catch (e) {
            print(e.message);
          }
          await firebaseAuth.signOut();
          _user = null;
          return null;
        } else
          return null;
      }

      DocumentSnapshot doc = query.documents.first;
      _model = ChatterUserModel(doc: doc);

      countryCode = _model.countryCode;
      return _user;
    });
  }

  @override
  Future<void> update(UserUpdateInfo userUpdateInfo) {
    return new Future(() async {
      _user = await firebaseAuth.currentUser();
      await firestore.collection('users').document(user.uid).setData({
        "id": user.uid,
        "userName": userUpdateInfo.displayName,
        "phoneNumber": user.phoneNumber,
        "photoUrl": userUpdateInfo.photoUrl,
        "platform": UserPlatform.chatter,
        "lastOnlineTime": DateTime.now().millisecondsSinceEpoch,
        "countryCode": {
          "dialCode": countryCode.dialCode, //ex: +1
          "code": countryCode.code, //ex: US
          "name": countryCode.name //ex: United States
        }
      });
      
      await _user.updateProfile(userUpdateInfo);
    });
  }
}
