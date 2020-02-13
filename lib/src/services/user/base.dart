import 'package:chatter/src/models/user/base.dart';

abstract class BaseUserService {
  UserModel _model;
  UserModel get model => _model;

  BaseUserService();

  Future<List<UserModel>> load();
  Future<List<UserModel>> findUsersByPhoneNumber({List<String> phoneNumbers});
}