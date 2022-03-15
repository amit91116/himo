import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:himo/ui/global/validator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as calendar;

const String event = "Event";
const String mobile = "Mobile";
const String email = "Email";

String removeSpaces(String value) {
  return value.replaceAll(RegExp(r"\s+"), "");
}

String getMonth(int month) {
  return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][month - 1];
}

List<Event> shortEvent(List<Event> events) {
  int currentYear = DateTime.now().year;
  events.sort(
      (a, b) => (a.day < b.day && a.month < b.month && (a.year ?? currentYear) < (b.year ?? currentYear)) ? -1 : 1);
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

Future<String?> getInput(BuildContext context, String title) async {
  TextEditingController _controller = TextEditingController();
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () => Navigator.pop(context, null),
  );
  Widget continueButton = TextButton(
    child: const Text("Add"),
    onPressed: () => Navigator.pop(context, _controller.text),
  );
  AlertDialog alert = AlertDialog(
    title: Text("Add $title"),
    content: title == event
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    controller: _controller, decoration: const InputDecoration(hintText: "Enter Event")),
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
                  initialDateTime: DateTime(1922, 1, 1),
                  maximumDate: DateTime(2922),
                  onDateTimeChanged: (DateTime newDateTime) {
                    // Do something
                  },
                ),
              ),
            ],
          )
        : TextFormField(
            controller: _controller,
            keyboardType: getInputType(title),
            validator: (value) => getValidator(title, value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(hintText: "Enter $title"),
          ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  return (await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  ));
}

getSuggestions(String pattern) {
  if (pattern.isEmpty) {
    return [];
  }
  return ["Anniversary", "Birthday", "Home", "Work"]
      .where((element) => element.toLowerCase().contains(pattern.toLowerCase()))
      .toList();
}

Future<XFile?> pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: source);
  return image;
}

Future<File?> cropImage(File? imageFile, BuildContext context) async {
  File? croppedFile = await ImageCropper().cropImage(
      maxHeight: 500,
      maxWidth: 500,
      sourcePath: imageFile!.path,
      cropStyle: CropStyle.circle,
      compressQuality: 100,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Adjust Contact Photo',
          toolbarColor: Theme.of(context).colorScheme.primary,
          toolbarWidgetColor: Theme.of(context).colorScheme.background,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false),
      iosUiSettings: const IOSUiSettings(
        title: 'Adjust Contact Photo',
      ));
  if (croppedFile != null) {
    return croppedFile;
  }
  return null;
}

TextInputType getInputType(String title) {
  if (title == email) {
    return TextInputType.emailAddress;
  } else if (title == mobile) {
    return TextInputType.phone;
  } else if (title == event) {
    return TextInputType.datetime;
  }
  return TextInputType.text;
}

String? getValidator(String title, String? value) {
  if (title == email) {
    return value != null && Validator.email(value, Validator.patternEmail) ? null : "Enter Valid Email";
  } else if (title == mobile) {
    return value != null && Validator.phone(value, Validator.patternPhone) ? null : "Enter Valid Phone";
  }
  return null;
}

callNumber(String number) async {
  await FlutterPhoneDirectCaller.callNumber(number);
}

Future addEvent(String title, DateTime dateTime, bool isEveryYear) async {
  final calendar.Event event = calendar.Event(
    title: title,
    startDate: dateTime,
    endDate: dateTime,
    allDay: true,
    iosParams: const calendar.IOSParams(
      reminder: Duration(days: 1), // on iOS, you can set alarm notification after your event.
    ),
    androidParams: const calendar.AndroidParams(
      emailInvites: [], // on Android, you can add invite emails to your event.
    ),
  );
  if (isEveryYear) {
    event.recurrence = calendar.Recurrence(frequency: calendar.Frequency.yearly);
  }
  await calendar.Add2Calendar.addEvent2Cal(event);
}
