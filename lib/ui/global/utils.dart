import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

String removeSpaces(String value) {
  return value.replaceAll(RegExp(r"\s+"), "");
}

String getMonth(int month) {
  return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][month - 1];
}

List<Event> shortEvent(List<Event> events) {
  int currentYear = DateTime.now().year;
  events.sort((a, b) => (a.day < b.day && a.month < b.month && (a.year ?? currentYear) < (b.year ?? currentYear)) ? -1 : 1);
  return events;
}

String getDate(Event event) {
  String date = "";
  date += event.day.toString();
  date += " - ";
  date += getMonth(event.month);
  date += " - ";
  if (event.year != null) {
    date += event.year.toString();
  } else {
    date += DateTime.now().year.toString();
  }
  return date;
}

Future<bool> confirmDelete(BuildContext context, String msg) async {
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () => Navigator.pop(context, false),
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () => Navigator.pop(context, true),
  );
  AlertDialog alert = AlertDialog(
    title: const Text("Confirm Delete"),
    content: Text(msg),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  return (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      )) ??
      false;
}
