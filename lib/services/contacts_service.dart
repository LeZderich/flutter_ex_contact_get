import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';


class ContactsService {

  static Future<List<Contact>> getContacts() async {
    await requestContactsPermission();
    await requestStoragePermission();
    List<Contact> contacts = await FlutterContacts.getContacts(withPhoto: true);
    return contacts;
  }

  static Future<Contact?> getContactById(id) async {
    Contact? contact = await FlutterContacts.getContact(id, withProperties: true, withPhoto: true);
    return contact;
  }

  static Future requestContactsPermission() async {
    bool result = await checkContactsPermission();
    if (!result) {
      await Permission.contacts.request();
    }
  }

  static Future requestStoragePermission() async {
    bool result = await checkStoragePermission();
    if (!result) {
      await Permission.storage.request();
    }
  }

  static Future<bool> checkContactsPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    if (!status.isGranted) {
      return false;
    }
    return true;
  }

  static Future<bool> checkStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      return false;
    }
    return true;
  }

  static Future<void> editContact(Contact contact) async {
    await FlutterContacts.openExternalEdit(contact.id);
  }

}
