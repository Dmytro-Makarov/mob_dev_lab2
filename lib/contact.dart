import 'package:flutter_contacts/flutter_contacts.dart';

Future<List<Contact>> getContactList() async {
  //List<Contact> contacts = await FlutterContacts.getContacts();

  List<Contact> contacts = await FlutterContacts.getContacts(
      withProperties: true, withThumbnail: true);

  return contacts;
}

Future<List<Contact>> getContactsStartingWith(String phoneNumber) async {
  List<Contact> contacts = await FlutterContacts.getContacts(
      withProperties: true, withThumbnail: true);

  List<Contact> newContacts = <Contact> [];

  for (final contact in contacts) {
    for (final phone in contact.phones) {
      int phonesMatched = 0;
      if (phone.normalizedNumber.startsWith(phoneNumber)) {
        phonesMatched++;
      }
      if (phonesMatched > 0) {
        newContacts.add(contact);
      }
    }
  }

  return newContacts;
}