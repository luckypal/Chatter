import 'package:chatter/src/models/user/base.dart';

abstract class MessageModel {
  String _id;
  UserModel _sender;
  List<UserModel> _receivers;
  int _sentTime;

  String get identifier => _id;
  UserModel get sender => _sender;
  List<UserModel> get receivers => _receivers;
  int get platform => _sender.platform;
  int get sentTime => _sentTime;

  MessageModel({String id, UserModel sender, List<UserModel> receivers, int sentTime}) {
    _id = id;
    _sender = sender;
    _receivers = receivers;
    _sentTime = sentTime;
  }
}
