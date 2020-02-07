import 'package:contacts_service/contacts_service.dart';

abstract class ContactService {
  List<Contact> _models;
  List<Contact> get model => _models;

  ContactService() {
    // load();
  }

  Future<Iterable<Contact>> load();
  void filter(Iterable<Contact> contacts);
}

class ContactServiceImpl extends ContactService {
  @override
  Future<Iterable<Contact>> load() {
    return new Future<Iterable<Contact>>(() async {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      filter(contacts);
      return contacts;
    });
  }

  @override
  void filter(Iterable<Contact> contacts) {
    _models = new List<Contact>();
    contacts.forEach((contact) {
      if (contact.phones.length == 0) return;
      _models.add(contact);
    });
  }
}
