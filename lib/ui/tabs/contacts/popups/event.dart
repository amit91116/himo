import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/event.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../global/utils.dart';

Future<Event?> getEvent(BuildContext context) async {
  TextEditingController _controller = TextEditingController();
  DateTime dateTime = DateTime.now();
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () => Navigator.pop(context, null),
  );
  Widget continueButton = TextButton(
    child: const Text("Add"),
    onPressed: () => Navigator.pop(
        context,
        Event(
          year: dateTime.year,
          month: dateTime.month,
          day: dateTime.day,
          label: _controller.text.toLowerCase() == EventLabel.birthday.name
              ? EventLabel.birthday
              : _controller.text.toLowerCase() == EventLabel.anniversary.name
                  ? EventLabel.anniversary
                  : EventLabel.custom,
          customLabel: _controller.text,
        )),
  );
  AlertDialog alert = AlertDialog(
    title: const Text("Add Event"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TypeAheadField(
          textFieldConfiguration:
              TextFieldConfiguration(controller: _controller, decoration: const InputDecoration(hintText: "Enter Event")),
          suggestionsCallback: (pattern) async {
            return await getSuggestions(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: Icon(suggestion.toString().toLowerCase() == EventLabel.anniversary.name
                  ? Icons.card_giftcard
                  : suggestion.toString().toLowerCase() == EventLabel.birthday.name
                      ? Icons.cake_rounded
                      : Icons.calendar_today_rounded),
              title: Text(suggestion.toString()),
            );
          },
          onSuggestionSelected: (suggestion) {
            _controller.text = suggestion.toString();
          },
        ),
        SizedBox(
          height: 156,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            maximumDate: DateTime(2922),
            onDateTimeChanged: (DateTime newDateTime) {
              dateTime = newDateTime;
            },
          ),
        ),
      ],
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  return (await showDialog<Event>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  ));
}
