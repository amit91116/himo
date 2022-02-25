import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/properties/event.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../global/utils.dart';

Future<Phone?> getMobile(BuildContext context) async {
  TextEditingController _controller = TextEditingController();
  TextEditingController value = TextEditingController();
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () => Navigator.pop(context, null),
  );
  Widget continueButton = TextButton(
    child: const Text("Add"),
    onPressed: () =>
        Navigator.pop(context, Phone(value.text, label: _controller.text.toLowerCase() == PhoneLabel.home.name
            ? PhoneLabel.home
            : _controller.text.toLowerCase() == PhoneLabel.work.name
            ? PhoneLabel.work
            : PhoneLabel.custom, customLabel: _controller.text)),
  );
  AlertDialog alert = AlertDialog(
    title: const Text("Add Mobile"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TypeAheadField(
          textFieldConfiguration:
          TextFieldConfiguration(controller: _controller, decoration: const InputDecoration(hintText: "Enter Mobile Type")),
          suggestionsCallback: (pattern) async {
            return await getSuggestions(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: Icon(suggestion.toString().toLowerCase() == PhoneLabel.work.name ? Icons.work_outline : Icons.home_outlined),
              title: Text(suggestion.toString()),
            );
          },
          onSuggestionSelected: (suggestion) {
            _controller.text = suggestion.toString();
          },
        ),
        TextFormField(
          controller: value,
          keyboardType: TextInputType.phone,
          validator: (value) => getValidator(mobile, value),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(hintText: "Enter Mobile"),
        )
      ],
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  return (await showDialog<Phone>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  ));
}
