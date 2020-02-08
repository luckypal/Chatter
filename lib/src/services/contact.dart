import 'dart:math';

import 'package:chatter/service_locator.dart';
import 'package:chatter/src/models/chatter_contact.dart';
import 'package:chatter/src/models/user.dart';
import 'package:chatter/src/utils/utilities.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:chatter/src/services/user.dart';

abstract class ContactService {
  UserService userService;
  List<ChatterContact> _models;
  List<ChatterContact> get model => _models;

  ContactService() {
    // load();
    userService = locator<UserService>();
  }

  Future<List<ChatterContact>> load();
  Future<void> filter(Iterable<Contact> contacts);
}

class ContactServiceImpl extends ContactService {
  @override
  Future<List<ChatterContact>> load() {
    return new Future<List<ChatterContact>>(() async {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      await filter(contacts);
      return _models;
    });
  }

  @override
  Future<void> filter(Iterable<Contact> contacts) async {
    return new Future<void>(() async {
      List<String> phoneNumbers = List<String>();

      Map<String, Contact> contactTable = Map<String, Contact>();

      contacts.forEach((contact) {
        if (contact.phones.length == 0) return;

        // contact.phones.forEach((phoneNumber) => phoneNumbers.add(phoneNumber.value));
        
        contact.phones.forEach((phoneNumber) {
          String newValue = Utilities.makeStandardPhoneNumber(phoneNumber.value);
          phoneNumbers.add(newValue);
          contactTable [newValue] = contact;
        });
      });

      _models = new List<ChatterContact>();

      int start = 0;
      while(start < phoneNumbers.length) {
        int end = min(start + 10, phoneNumbers.length);
        List<String> subPhoneNumbers = phoneNumbers.sublist(start, end);
        List<ChatterUserModel> userList = await userService.findUsers(phoneNumbers: subPhoneNumbers);
        
        userList.forEach((chatterUser) {
          ChatterContact chatterContact = new ChatterContact();
          chatterContact.chatterModel = chatterUser;
          chatterContact.contact = contactTable[chatterUser.phoneNumber];

          _models.add(chatterContact);
        });

        start += 10;
      }
    });
  }
}
