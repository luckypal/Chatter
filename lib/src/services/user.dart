import 'package:firebase_auth/firebase_auth.dart';

abstract class UserService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  FirebaseUser get user => _user;

  UserService() {
    load();
  }

  Future<FirebaseUser> load();
}

class UserServiceImpl extends UserService {
  @override
  Future<FirebaseUser> load() {
    return new Future(() async {
      this._user = await firebaseAuth.currentUser();
      return user;
    });
  }
}