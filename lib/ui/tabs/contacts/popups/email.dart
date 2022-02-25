import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/properties/event.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../global/utils.dart';

Future<Email?> getEmail(BuildContext context) async {
  TextEditingController _controller = TextEditingController();
  TextEditingController value = TextEditingController();
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () => Navigator.pop(context, null),
  );
  Widget continueButton = TextButton(
    child: const Text("Add"),
    onPressed: () => Navigator.pop(
        context,
        Email(value.text,
            label: _controller.text.toLowerCase() == EmailLabel.home.name
                ? EmailLabel.home
                : _controller.text.toLowerCase() == EmailLabel.work.name
                    ? EmailLabel.work
                    : EmailLabel.custom,
            customLabel: _controller.text)),
  );
  AlertDialog alert = AlertDialog(
    title: const Text("Add Email"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TypeAheadField(
          textFieldConfiguration:
              TextFieldConfiguration(controller: _controller, decoration: const InputDecoration(hintText: "Enter Email Type")),
          suggestionsCallback: (pattern) async {
            return await getSuggestions(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: Icon(suggestion.toString().toLowerCase() == EmailLabel.work.name ? Icons.work_outline : Icons.home_outlined),
              title: Text(suggestion.toString()),
            );
          },
          onSuggestionSelected: (suggestion) {
            _controller.text = suggestion.toString();
          },
        ),
        TextFormField(
          controller: value,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => getValidator(email, value),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(hintText: "Enter Email"),
        )
      ],
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  return (await showDialog<Email>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  ));
}
