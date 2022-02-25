import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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
          toolbarTitle: 'Crop Contact Photo',
          toolbarColor: Theme.of(context).colorScheme.primary,
          toolbarWidgetColor: Theme.of(context).colorScheme.background,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false),
      iosUiSettings: const IOSUiSettings(
        title: 'Crop Contact Photo',
      ));
  if (croppedFile != null) {
    return croppedFile;
  }
  return null;
}

