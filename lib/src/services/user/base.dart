import 'package:chatter/src/models/user/base.dart';

abstract class BaseUserService {
  BaseUserService();

  Future<List<UserModel>> load();
  List<UserModel> findContacts(String searchText);
  Future<List<UserModel>> findUsersByPhoneNumber({List<String> phoneNumbers});
}