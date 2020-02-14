import 'dart:math';
import 'package:chatter/src/services/user/base.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatter/src/models/user/chatter.dart';
import 'package:chatter/src/utils/utilities.dart';

abstract class ChatterUserService extends BaseUserService {
  static const String COLLECTION_NAME = "users";

  final Firestore firestore = Firestore.instance;
  List<ChatterUserModel> get models => super.models;

  ChatterUserService();
}

class ChatterUserServiceImpl extends ChatterUserService {
  @override
  Future<List<ChatterUserModel>> load() {
    return new Future<List<ChatterUserModel>>(() async {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      await filterWithServer(contacts);
      return models;
    });
  }

  @override
  List<ChatterUserModel> findContacts(String searchText) {
    List<ChatterUserModel> contactsResult = new List<ChatterUserModel>();
    searchText = searchText.toLowerCase();

    models.forEach((contact) {
      if (contact.userName.toLowerCase().contains(searchText) ||
          contact.phoneNumber.toLowerCase().contains(searchText))
        contactsResult.add(contact);
    });

    return contactsResult;
  }

  @override
  Future<List<ChatterUserModel>> findUsersByPhoneNumber({List<String> phoneNumbers}) {
    return new Future<List<ChatterUserModel>>(() async {
      List<ChatterUserModel> users = new List<ChatterUserModel>();
      QuerySnapshot query = await firestore
          .collection(ChatterUserService.COLLECTION_NAME)
          .where("phoneNumber", whereIn: phoneNumbers)
          .getDocuments();
      query.documents.forEach((doc) {
        users.add(new ChatterUserModel(doc: doc));
      });

      return users;
    });
  }

  Future<void> filterWithServer(Iterable<Contact> contacts) async {
    return new Future<void>(() async {
      // List<String> phoneNumbers = List<String>();

      Map<String, Contact> contactTable = Map<String, Contact>();

      contacts.forEach((contact) {
        if (contact.phones.length == 0) return;

        contact.phones.forEach((phoneNumber) {
          String newValue =
              Utilities.makeStandardPhoneNumber(phoneNumber.value);
          contactTable[newValue] = contact;
        });
      });

      int start = 0;
      models = new List<ChatterUserModel>();
      List<String> phoneNumbers = contactTable.keys.toList(growable: false);
      // await serverService.findPhones(phoneNumbers);

      while (start < phoneNumbers.length) {
        int end = min(start + 10, phoneNumbers.length);
        List<String> subPhoneNumbers = phoneNumbers.sublist(start, end);
        List<ChatterUserModel> userList =
            await findUsersByPhoneNumber(phoneNumbers: subPhoneNumbers);

        userList.forEach((chatterUser) {
          chatterUser.contact = contactTable[chatterUser.phoneNumber];

          models.add(chatterUser);
        });

        start += 10;
      }
    });
  }
}
