import 'package:chatter/src/models/user/base.dart';

abstract class BaseUserService {
  List<UserModel> _models;
  get models => _models;
  set models(List<UserModel> value) => _models = value;

  BaseUserService();

  Future<List<UserModel>> load();

  List<UserModel> findContacts(String searchText);
  
  Future<UserModel> findUserByIdentifier(String identifier) async {
    int index = 0;
    int foundPos = -1;

    if (_models == null) return null;

    _models.forEach((item) {
      if (item.identifier == identifier) foundPos = index;
      index++;
    });

    if (foundPos == -1) return null;
    return _models[foundPos];
  }

  Future<List<UserModel>> findUsersByPhoneNumber({List<String> phoneNumbers});
  Future<List<UserModel>> findUsersByIds({List<String> contactIds});
}
