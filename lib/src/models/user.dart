import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;

enum UserState { available, away, busy }
class UserPlatform {   //chatter, facebook / instagram / ...
  static final int chatter = 0;
  static final int facebook = 1;
  // ...
}

abstract class UserModel {
  String id;
  String userName;
  String phoneNumber;
  String photoUrl;
  int platform;
  int lastOnlineTime;
  UserState userState;

  static void loadFromId({String id}) {
    
  }
  static void loadFromUserName({String userName}) {}
  static void loadFromPhoneNumber({String phoneNumber, int platform}) {}

  void load(DocumentSnapshot doc);
  void setUserState() {}
}

class ChatterUserModel extends UserModel {
  CountryCode countryCode;

  ChatterUserModel({DocumentSnapshot doc}) {
    load(doc);
  }

  void load(DocumentSnapshot doc) {
    dynamic data = doc.data;

    id = doc.documentID;
    userName = data["userName"];
    phoneNumber = data["phoneNumber"];
    photoUrl = data["photoUrl"];
    platform = data["platform"];
    lastOnlineTime = data["lastOnlineTime"];

    countryCode = new CountryCode(
      dialCode: data["countryCode"]["dialCode"],
      code: data["countryCode"]["code"],
      name: data["countryCode"]["name"]
    );

    setUserState();
  }
}
