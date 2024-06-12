import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../services/contacts_service.dart';

class ContactDetails extends StatefulWidget {
  final String id;
  const ContactDetails(this.id, {super.key});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  late Future<Contact?> _contactFuture;

  @override
  void initState() {
    super.initState();
    _contactFuture = ContactsService.getContactById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
      ),
      body: FutureBuilder<Contact?>(
        future: _contactFuture,
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
            Contact contact = snapshot.data!;
            String displayName = contact.displayName;
            List<Phone> phones = contact.phones;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: contact.photo != null ? MemoryImage(contact.photo!) : null,
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: InkWell(
                        onTap: () async {
                          await ContactsService.editContact(contact);
                          setState(() {
                            _contactFuture = ContactsService.getContactById(contact.id);
                          });
                        },
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 20,
                      ),
                    )
                    ),
                  ],
                ),
              ],
            ),
                const SizedBox(height: 50),
                Text(displayName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 50),
                for (Phone phone in phones)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(phone.number, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
              ],
            );
          }
        },
      ),
    );
  }

}

