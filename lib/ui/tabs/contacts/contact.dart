import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatefulWidget {
  final Contact contact;

  const ContactDetails({Key? key, required this.contact}) : super(key: key);

  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Text(widget.contact.displayName ?? ''),
        ],
      ),
    );
  }
}
