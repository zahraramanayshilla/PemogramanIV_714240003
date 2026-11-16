import 'package:flutter/material.dart';

import 'contact_model.dart';

class ContactStore extends ChangeNotifier {
  final List<ContactModel> _contacts = [];

  List<ContactModel> get contacts => List.unmodifiable(_contacts);

  // Menambahkan kontak
  void addContact(ContactModel contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  // Mengubah kontak
  void updateContact(int index, ContactModel contact) {
    if (index >= 0 && index < _contacts.length) {
      _contacts[index] = contact;
      notifyListeners();
    }
  }

  // Menghapus kontak
  void deleteContact(int index) {
    if (index >= 0 && index < _contacts.length) {
      _contacts.removeAt(index);
      notifyListeners();
    }
  }
}
