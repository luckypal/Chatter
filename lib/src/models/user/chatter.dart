import 'package:chatter/src/models/user/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:contacts_service/contacts_service.dart';

class ChatterUserModel extends UserModel {
  static const String COLLECTION_NAME = "users";

  CountryCode countryCode;
  
  Contact _contact;
  dynamic get contact => _contact;
  set contact(dynamic value) => _contact = value;

  List<String> contactIds;
  
  String get userName => _contact != null ? _contact.displayName : super.userName;

  ChatterUserModel({DocumentSnapshot doc}) {
    load(doc);
  }

  void load(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data;

    setValue({
      "id": doc.documentID,
      "userName": data["userName"],
      "phoneNumber": data["phoneNumber"],
      "photoUrl": data["photoUrl"],
      "platform": data["platform"],
      "lastOnlineTime": data["lastOnlineTime"]
    });

    if (data["contactIds"] != null) {
      contactIds = List<String>();
      for (String contactId in data["contactIds"])
        contactIds.add(contactId);
    }

    countryCode = new CountryCode(
      dialCode: data["countryCode"]["dialCode"],
      code: data["countryCode"]["code"],
      name: data["countryCode"]["name"]
    );

    // setUserState();
  }

  static DocumentReference getDocumentRef(identifier) {
    return Firestore.instance.collection(ChatterUserModel.COLLECTION_NAME).document(identifier);
  }
}
