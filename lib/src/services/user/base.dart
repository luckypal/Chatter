import 'package:chatter/src/models/user/base.dart';

abstract class BaseUserService {
  List<UserModel> _models;
  get models => _models;
  set models(List<UserModel> value) => _models = value;

  BaseUserService();

  Future<List<UserModel>> load();
  List<UserModel> findContacts(String searchText);
  Future<List<UserModel>> findUsersByPhoneNumber({List<String> phoneNumbers});
}