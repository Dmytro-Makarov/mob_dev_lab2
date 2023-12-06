import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:mob_dev_lab2/contact.dart';
import 'package:permission_handler/permission_handler.dart';

import 'oblast_page.dart';

Widget contactCard(Contact contact) {
  var phoneColumn = <Widget> [];
  for (final phone in contact.phones) {
    phoneColumn.add(Text(phone.normalizedNumber));
  }

  return Card(
    child: ListTile(
      leading:
          (){
        if (contact.thumbnail != null) {
          return Image.memory(contact.thumbnail as Uint8List);
        } else {
          return const Icon(Icons.person);
        }
      }(),
      title: Text(contact.displayName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: phoneColumn,),
    ),
  );
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});


  @override
  State<ContactPage> createState() => _ContactPage();
}

Future<List<Contact>> requestContacts() async {
  Future<List<Contact>> contacts = Future(() => <Contact>[]);
  final status = await Permission.contacts.request();

  if(status.isGranted){
    contacts = getContactList();
  }
  return contacts;
}

class _ContactPage extends State<ContactPage> {
  late Future<List<Contact>> contacts;

  @override
  void initState() {
    super.initState();

    contacts = requestContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      FutureBuilder<List<Contact>>(
          future: contacts,
          builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
            ListView listView;
            if (snapshot.hasData) {
              listView = ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return contactCard(snapshot.data!.elementAt(index));
                  });
              return Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(onPressed: () => {
                  setState(() { contacts = getContactsStartingWith("+38097"); })
                },
                    child: const Text("Filter by '+38097'")),
                Expanded(child: listView)
              ],);

            } else if (snapshot.hasError) {
              return builderError(snapshot);
            } else {
              return progressBar();
            }
          })
    );

  }

}
