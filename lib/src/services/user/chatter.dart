import 'dart:math';
import 'package:chatter/service_locator.dart';
import 'package:chatter/src/services/user/base.dart';
import 'package:chatter/src/services/user/owner.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatter/src/models/user/chatter.dart';
import 'package:chatter/src/utils/utilities.dart';

abstract class ChatterUserService extends BaseUserService {
  static const String COLLECTION_NAME = "users";

  final Firestore firestore = Firestore.instance;
  List<ChatterUserModel> get models => super.models;
  
  OwnerUserService ownerUserService;

  ChatterUserService() {
    ownerUserService = locator<OwnerUserService>();
  }
}

class ChatterUserServiceImpl extends ChatterUserService {
  @override
  Future<List<ChatterUserModel>> load() {
    return new Future<List<ChatterUserModel>>(() async {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      if (models == null)
        models = new List<ChatterUserModel>();
      else models.clear();
      
      await filterWithFirebase(contacts);
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
  Future<ChatterUserModel> findUserByIdentifier(String identifier) async {
    ChatterUserModel model = await super.findUserByIdentifier(identifier);

    if (model != null) return model;
    
    DocumentSnapshot doc = await firestore.collection(ChatterUserService.COLLECTION_NAME).document(identifier).get();
    return ChatterUserModel(doc: doc);
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

  @override
  Future<List<ChatterUserModel>> findUsersByIds({List<String> contactIds}) {
    return new Future<List<ChatterUserModel>>(() async {
      List<ChatterUserModel> users = new List<ChatterUserModel>();
      QuerySnapshot query = await firestore
          .collection(ChatterUserService.COLLECTION_NAME)
          .where("id", whereIn: contactIds)
          .getDocuments();
      query.documents.forEach((doc) {
        users.add(new ChatterUserModel(doc: doc));
      });

      return users;
    });
  }

  Future<void> filterWithFirebase(Iterable<Contact> contacts) async {
    return new Future<void>(() async {
      List<String> contactIds = this.ownerUserService.contactIds;
      if (contactIds == null)
        getContactsFromPhoneContacts(contacts);
      else
        getContactsFromIds(contacts, contactIds);
    });
  }

  Map<String, Contact> convertContactsByPhoneNumber(Iterable<Contact> contacts) {
    Map<String, Contact> contactTable = Map<String, Contact>();

    contacts.forEach((contact) {
      if (contact.phones.length == 0) return;

      contact.phones.forEach((phoneNumber) {
        String newValue =
            Utilities.makeStandardPhoneNumber(phoneNumber.value);
        contactTable[newValue] = contact;
      });
    });

    return contactTable;
  }

  /**
   * - Extract phone numbers from contacts
   * - Get contacts from firebase using the phone numbers
   */
  Future<void> getContactsFromPhoneContacts(Iterable<Contact> contacts) async {
    Map<String, Contact> contactTable = convertContactsByPhoneNumber(contacts);

    int start = 0;
    List<String> phoneNumbers = contactTable.keys.toList(growable: false);
    // await serverService.findPhones(phoneNumbers);
    List<String> contactIds = new List<String>();

    while (start < phoneNumbers.length) {
      int end = min(start + 10, phoneNumbers.length);
      List<String> subPhoneNumbers = phoneNumbers.sublist(start, end);
      List<ChatterUserModel> userList =
          await findUsersByPhoneNumber(phoneNumbers: subPhoneNumbers);

      userList.forEach((chatterUser) {
        chatterUser.contact = contactTable[chatterUser.phoneNumber];

        models.add(chatterUser);
        contactIds.add(chatterUser.identifier);
      });

      start += 10;
    }

    ownerUserService.contactIds = contactIds;
  }

  /**
   * Get contacts from contact Id list
   */
  Future<void> getContactsFromIds(Iterable<Contact> contacts, List<String> contactIds) async {
    Map<String, Contact> contactTable = convertContactsByPhoneNumber(contacts);

    int start = 0;
    while(start < contactIds.length) {
      int end = min(start + 10, contactIds.length);
      List<String> subContactIds = contactIds.sublist(start, end);
      List<ChatterUserModel> userList = await findUsersByIds(contactIds: subContactIds);

      userList.forEach((chatterUser) {
        chatterUser.contact = contactTable[chatterUser.phoneNumber];

        models.add(chatterUser);
      });

      start += 10;
    }
  }
}
