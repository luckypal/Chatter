import 'package:chatter/src/models/user.dart';
import 'package:contacts_service/contacts_service.dart';

abstract class BaseContact {
  int platform; //UserPlatform
  dynamic _contact;
  UserModel _userModel;

  dynamic get contact => _contact;
  set contact(dynamic value) => _contact = value;

  UserModel get userModel => _userModel;
  set userModel(UserModel value) => _userModel = value;

  String get name => _userModel.userName;
}

class ChatterContact extends BaseContact {
  Contact get contact => _contact;
  ChatterUserModel get userModel => _userModel;

  String get name => _contact.displayName;
}
