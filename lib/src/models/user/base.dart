enum UserState { available, away, busy }

class ChatPlatform {
  //chatter, facebook / instagram / ...
  static const int chatter = 0;
  static const int facebook = 1;
  // ...
}

abstract class UserModel {
  String _id;
  String _userName;
  String _phoneNumber;
  String _photoUrl;
  int _platform; //User Platform
  int _lastOnlineTime;
  UserState _userState;

  String get identifier => _id;
  String get userName => _userName;
  String get photoUrl => _photoUrl;
  String get phoneNumber => _phoneNumber;
  int get platform => _platform;
  int get lastOnlineTime => _lastOnlineTime;
  UserState get userState => _userState;

  // static void loadFromId({String id}) {}
  // static void loadFromUserName({String userName}) {}
  // static void loadFromPhoneNumber({String phoneNumber, int platform}) {}

  // void load(Object args);
  // void setUserState() {}
  
  void setValue(Map<String, dynamic> values) {
    _id = values["id"];
    _userName = values["userName"];
    _phoneNumber = values["phoneNumber"];
    _photoUrl = values["photoUrl"];
    _platform = values["platform"];
    _lastOnlineTime = values["lastOnlineTime"];
    _userState = values["userState"];
  }
}
