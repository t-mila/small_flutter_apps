import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _contactData = '';

  @override
  void initState() {
    super.initState();
    _getContact();
  }

  Future<void> _getContact() async {
    if (!await _requestPermission()) {
      setState(() {
        _contactData = 'Permission denied';
      });
      return;
    }

    final Iterable<Contact> contacts = await ContactsService.getContacts();

    if (contacts.length == 0) {
      setState(() {
        _contactData = 'No contacts found';
      });
      return;
    }

    final Contact contact = contacts.first;
    final String displayName = contact.displayName ?? '';

    final List<Item>? phones = contact.phones?.toList();
    if (phones == null || phones.length == 0) {
      setState(() {
        _contactData = '$displayName has no phone numbers';
      });
      return;
    }

    final Item phone = phones.first;
    final String phoneNumber = phone.value ?? '';

    if (phoneNumber.isNotEmpty) {
      setState(() {
        _contactData = '$displayName: $phoneNumber';
      });
      return;
    } else {
      setState(() {
        _contactData = '$displayName has no phone numbers';
      });
      return;
    }
  }

  Future<bool> _requestPermission() async {
    if (await Permission.contacts.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contacts Example'),
        ),
        body: Center(
          child: Text(_contactData),
        ),
      ),
    );
  }
}
