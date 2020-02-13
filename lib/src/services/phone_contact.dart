import 'dart:math';

import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/user/chatter.dart';
import 'package:chatter/src/services/server.dart';
import 'package:chatter/src/utils/utilities.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:chatter/src/services/user/chatter.dart';

abstract class PhoneContactService {
  ChatterUserService chatterUserService;
  ServerService serverService;
  List<ChatterUserModel> _models;
  List<ChatterUserModel> get model => _models;

  PhoneContactService() {
    // load();
    chatterUserService = locator<ChatterUserService>();
    serverService = locator<ServerService>();
  }

  Future<List<ChatterUserModel>> load();
  Future<void> filterWithServer(Iterable<Contact> contacts);
  List<ChatterUserModel> filterContacts(String filterText);
}

class PhoneContactServiceImpl extends PhoneContactService {
  @override
  Future<List<ChatterUserModel>> load() {
    return new Future<List<ChatterUserModel>>(() async {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      await filterWithServer(contacts);
      return _models;
    });
  }

  @override
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
      _models = new List<ChatterUserModel>();
      List<String> phoneNumbers = contactTable.keys.toList(growable: false);
      // await serverService.findPhones(phoneNumbers);

      while (start < phoneNumbers.length) {
        int end = min(start + 10, phoneNumbers.length);
        List<String> subPhoneNumbers = phoneNumbers.sublist(start, end);
        List<ChatterUserModel> userList =
            await chatterUserService.findUsersByPhoneNumber(phoneNumbers: subPhoneNumbers);

        userList.forEach((chatterUser) {
          chatterUser.contact = contactTable[chatterUser.phoneNumber];

          _models.add(chatterUser);
        });

        start += 10;
      }
    });
  }

  @override
  List<ChatterUserModel> filterContacts(String filterText) {
    List<ChatterUserModel> contactsResult = new List<ChatterUserModel>();
    filterText = filterText.toLowerCase();

    model.forEach((contact) {
      if (contact.userName.toLowerCase().contains(filterText) ||
          contact.phoneNumber.toLowerCase().contains(filterText))
        contactsResult.add(contact);
    });

    return contactsResult;
  }
}
