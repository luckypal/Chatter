import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;
  FirebaseUser _user;
  FirebaseUser get user => _user;

  UserService() {
    load();
  }

  Future<FirebaseUser> load();
  Future<void> saveToDatabase(UserUpdateInfo userUpdateInfo);
}

class UserServiceImpl extends UserService {
  @override
  Future<FirebaseUser> load() {
    return new Future(() async {
      this._user = await firebaseAuth.currentUser();
      return user;
    });
  }

  @override
  Future<void> saveToDatabase(UserUpdateInfo userUpdateInfo) {
    return new Future(() async {
      await firestore.collection('users').document(user.uid).setData({
        "userName": userUpdateInfo.displayName,
        "phoneNumber": user.phoneNumber,
        "photoUrl": userUpdateInfo.photoUrl,
      });
    });
  }
}