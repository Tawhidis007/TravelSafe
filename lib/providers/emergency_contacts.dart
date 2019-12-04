import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmergencyContactItem {
  final String id;
  String name;
  String phoneNumber;
  String relation;

  EmergencyContactItem({
    this.id,
    this.phoneNumber,
    this.name,
    this.relation,
  });
}

class EmergencyContacts with ChangeNotifier {
  List<EmergencyContactItem> _contactList = [];

  List<EmergencyContactItem> get contactList {
    return [..._contactList];
  }

  EmergencyContactItem findById(String id) {
    return _contactList.firstWhere((contact) => id == contact.id);
  }

  Future<void> updateContact(
      String id, EmergencyContactItem emergencyContactItem) async {
    final url = 'https://safetravel-bc03a.firebaseio.com/contacts/$id.json';
    final cIndex = _contactList.indexWhere((c) => c.id == id);
    try {
      final response = await http.patch(url,
          body: json.encode({
            'name': emergencyContactItem.name,
            'relation': emergencyContactItem.relation,
            'phoneNumber': emergencyContactItem.phoneNumber,
          }));
      _contactList[cIndex] = emergencyContactItem;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addContact(EmergencyContactItem emergencyContactItem) async {
    const url = 'https://safetravel-bc03a.firebaseio.com/contacts.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'name': emergencyContactItem.name,
            'relation': emergencyContactItem.relation,
            'phoneNumber': emergencyContactItem.phoneNumber,
          }));
      print(json.decode(response.body));
      final newContact = EmergencyContactItem(
          phoneNumber: emergencyContactItem.phoneNumber,
          relation: emergencyContactItem.relation,
          name: emergencyContactItem.name,
          id: json.decode(response.body)['name']);
      _contactList.add(newContact);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetContacts() async {
    final url = 'https://safetravel-bc03a.firebaseio.com/contacts.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      List<EmergencyContactItem> loadedC = [];
      extractedData.forEach((cId, cData) {
        loadedC.add(EmergencyContactItem(
            id: cId,
            name: cData['name'],
            relation: cData['relation'],
            phoneNumber: cData['phoneNumber']));
      });
      _contactList = loadedC;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
