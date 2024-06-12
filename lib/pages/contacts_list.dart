import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import '../services/contacts_service.dart';
import 'contact_details.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});
  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  late Future<List<Contact>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _contactsFuture = ContactsService.getContacts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: FutureBuilder<List<Contact>>(
        future: _contactsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Contact contact = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: contact.photoOrThumbnail != null ? MemoryImage(contact.photoOrThumbnail!) : null,
                    child: contact.photoOrThumbnail == null ? Text(contact.displayName[0]) : null,
                  ),
                  title: Text(contact.displayName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactDetails(contact.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}