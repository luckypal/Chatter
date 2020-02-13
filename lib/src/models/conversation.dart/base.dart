import 'package:chatter/src/models/user/base.dart';

abstract class ConversationModel {
  String _id;
  List<UserModel> _users;
  int _createdTime;

  String get identifier => _id;
  List<UserModel> get users => _users;
  int get platform => _users [0].platform;
  int get createdTime => _createdTime;

  ConversationModel({String id, List<UserModel> users, int createdTime}) {
    _id = id;
    _users = users;
    _createdTime = createdTime;
  }
}
