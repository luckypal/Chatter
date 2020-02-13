/*import 'package:chatter/src/models/user.dart';
import 'package:contacts_service/contacts_service.dart';

abstract class BaseContact {
  dynamic _contact;
  UserModel _userModel;

  dynamic get contact => _contact;
  set contact(dynamic value) => _contact = value;

  UserModel get userModel => _userModel;
  set userModel(UserModel value) => _userModel = value;

  String get identifier => _userModel.id;
  String get name => _userModel.userName;
  String get photoUrl => _userModel.photoUrl;
  String get phoneNumber => _userModel.phoneNumber;
  int get platform => _userModel.platform;
}

class ChatterContact extends BaseContact {
  Contact get contact => _contact;
  ChatterUserModel get userModel => _userModel;

  String get name => _contact.displayName;
}
*/