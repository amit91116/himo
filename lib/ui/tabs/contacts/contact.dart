import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:himo/ui/global/call_logs/bloc/call_logs_bloc.dart';
import 'package:himo/ui/global/constants.dart';
import 'package:himo/ui/global/contacts/bloc/contacts_bloc.dart';
import 'package:himo/ui/global/static_visual.dart';
import 'package:himo/ui/global/widgets/contact_call_log.dart';
import 'package:himo/ui/global/widgets/icon_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/string_extension.dart';
import '../../global/utils.dart';

class ContactDetails extends StatefulWidget {
  final String contactId;

  const ContactDetails({Key? key, required this.contactId}) : super(key: key);

  @override
  _ContactDetailsState createState() => _ContactDetailsState(contactId);
}

class _ContactDetailsState extends State<ContactDetails> {
  final String contactId;

  _ContactDetailsState(this.contactId);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContactsBloc>(context).add(GetContact(contactId));
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = StaticVisual.usableWidth(context);
    return Scaffold(
      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (context, state) {
          if (state is ContactFound) {
            BlocProvider.of<CallLogsBloc>(context).add(LoadCallLogsForContactByName(state.contact.displayName));
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 32, bottom: 16),
                  width: maxWidth,
                  height: 116,
                  child: getProfileStatic(state.contact, maxWidth),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<CallLogsBloc, CallLogsState>(builder: (context, state) {
                          if (state is CallLogsLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is CallLogsLoaded) {
                            return getLogsDetails(state, maxWidth);
                          }
                          return Container();
                        }),
                        getHeading("Events"),
                        getEvents(state.contact),
                        getHeading("Mobiles"),
                        getPhoneNumbers(state.contact),
                        getHeading("Emails"),
                        getEmails(state.contact),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  String getFullName(Contact contact) {
    String output = contact.displayName;
    if (output == "" && contact.phones.isNotEmpty) {
      output = contact.phones[0].number;
    }
    return output;
  }

  String getPrimaryPhone(Contact contact) {
    return (contact.phones.isNotEmpty) ? contact.phones[0].number : "";
  }

  Widget getProfileStatic(Contact contact, double maxWidth) {
    return Row(
      children: [
        Container(
          width: 116,
          height: 116,
          margin: const EdgeInsets.only(left: 16),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(58)),
          ),
          child: (contact.thumbnail != null)
              ? GestureDetector(
                  onTap: () => showProfilePicture(true, contact),
                  child: CircleAvatar(
                    backgroundImage: MemoryImage(contact.photoOrThumbnail!),
                  ),
                )
              : GestureDetector(
                  onTap: () => showProfilePicture(false, contact),
                  child: CircleAvatar(
                    child: Text(
                      getFullName(contact).initials(),
                      textScaleFactor: 3.5,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StaticVisual.smallHeight,
            Text(getFullName(contact), textScaleFactor: 2),
            StaticVisual.smallHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: () => _callNumber(getPrimaryPhone(contact)), child: const Icon(Icons.call)),
                TextButton(
                    onPressed: () => {
                          sendSMS(message: "", recipients: [getPrimaryPhone(contact)])
                        },
                    child: const Icon(Icons.message)),
                Visibility(
                  visible: (contact.emails.isNotEmpty),
                  child: TextButton(
                      onPressed: (contact.emails.isNotEmpty) ? () => {_sendEmail(contact.emails[0].address)} : null,
                      child: const Icon(Icons.email)),
                ),
                TextButton(onPressed: () => launch("whatsapp://send?phone=${getPrimaryPhone(contact)}"), child: Constants.whatsAppIcon),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget getEvents(Contact contact) {
    if (contact.events.isEmpty) {
      return Column(
        children: const [
          ListTile(
            leading: Icon(Icons.close),
            title: Text("No Event found!"),
          ),
        ],
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, bottom: 16, top: 16),
        physics: const BouncingScrollPhysics(),
        child: Expanded(
          child: Row(
              children: shortEvent(contact.events)
                  .map((e) => Container(
                        decoration: StaticVisual.boxDec(context),
                        margin: const EdgeInsets.only(right: 16),
                        height: 72,
                        width: 128,
                        child: Stack(
                          children: [
                            Positioned(
                              right: -8,
                              bottom: 0,
                              child: Icon(
                                e.label == EventLabel.anniversary
                                    ? Icons.card_giftcard
                                    : e.label == EventLabel.birthday
                                        ? Icons.cake_rounded
                                        : Icons.calendar_today_rounded,
                                size: 72,
                                color: StaticVisual.bgIconColor(context),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              right: 0,
                              bottom: 0,
                              child: Column(
                                children: [
                                  StaticVisual.mediumHeight,
                                  Text(
                                    getDate(e),
                                    textScaleFactor: 1.1,
                                  ),
                                  Text(e.customLabel.isNotEmpty ? e.customLabel : e.label.name.capitalize()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList()),
        ),
      );
    }
  }

  Column getPhoneNumbers(Contact contact) {
    if (contact.phones.isEmpty) {
      return Column(
        children: const [
          ListTile(
            leading: Icon(Icons.phone_disabled),
            title: Text("No phone found!"),
          ),
        ],
      );
    }
    Set<String> phones = <String>{};
    List<Phone> items = contact.phones.where((element) => phones.add(removeSpaces(element.number))).toList();
    return Column(
        children: items
            .map(
              (phone) => Slidable(
                key: Key(phone.number),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => {deletePhoneNumber(context, contact, phone)},
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.background,
                      icon: Icons.delete_forever_outlined,
                      label: 'Delete',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => {
                        sendSMS(message: "", recipients: [phone.number])
                      },
                      backgroundColor: const Color(0xFFF86B00),
                      foregroundColor: Theme.of(context).colorScheme.background,
                      icon: Icons.message_outlined,
                      label: 'Message',
                    ),
                    SlidableAction(
                      onPressed: (context) => {launch("whatsapp://send?phone=${phone.number}")},
                      backgroundColor: Colors.green,
                      foregroundColor: Theme.of(context).colorScheme.background,
                      icon: Icons.whatsapp_outlined,
                      label: 'WhatsApp',
                      autoClose: true,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    phone.label.name == "work" ? Icons.work_outline : Icons.home_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(phone.number),
                  trailing: TextButton(onPressed: () => _callNumber(phone.number), child: const Icon(Icons.call_outlined)),
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: phone.number));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied")));
                  },
                  onTap: () => launch("tel://${phone.number}"),
                ),
              ),
            )
            .toList());
  }

  Column getEmails(Contact contact) {
    if (contact.emails.isEmpty) {
      return Column(
        children: const [
          ListTile(
            leading: Icon(Icons.unsubscribe),
            title: Text("No email found!"),
          ),
        ],
      );
    }
    Set<String> emails = <String>{};
    List<Email> items = contact.emails.where((element) => emails.add(element.address)).toList();
    return Column(
        children: items
            .map(
              (email) => Slidable(
                key: Key(email.address),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => {deleteEmail(context, contact, email)},
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.background,
                      icon: Icons.delete_forever_outlined,
                      label: 'Delete',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => {_sendEmail(email.address)},
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.background,
                      icon: Icons.send,
                      label: 'Email',
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    email.label.name == "work" ? Icons.work_outline : Icons.home_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(email.address),
                  trailing: TextButton(onPressed: () => {_sendEmail(email.address)}, child: const Icon(Icons.email_outlined)),
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: email.address));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied")));
                  },
                ),
              ),
            )
            .toList());
  }

  Widget getHeading(String heading) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        heading,
        textScaleFactor: 1,
      ),
    );
  }

  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  _sendEmail(String email) {
    launch("mailto:$email");
  }

  Widget getLogsDetails(CallLogsLoaded logs, double maxWidth) {
    return Container(
      width: maxWidth,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 96,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ContactCallLog(logs: logs.incommingCalls),
          ContactCallLog(logs: logs.outgoingCalls),
          ContactCallLog(logs: logs.missedCalls),
        ],
      ),
    );
  }

  Widget getDeleteBackground(BuildContext context, Alignment direction) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: direction,
      decoration: const BoxDecoration(color: Colors.red),
      child: Icon(
        Icons.delete,
        color: Theme.of(context).colorScheme.background,
      ),
    );
  }

  deletePhoneNumber(BuildContext context, Contact contact, Phone phone) async {
    Contact updatedContact = contact;
    updatedContact.phones.remove(phone);
    BlocProvider.of<ContactsBloc>(context).add(UpdateContact(updatedContact));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Phone deleted!", style: StaticVisual.error),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            updatedContact.phones.add(phone);
            BlocProvider.of<ContactsBloc>(context).add(UpdateContact(updatedContact));
          },
        ),
      ),
    );
  }

  deleteEmail(BuildContext context, Contact contact, Email email) {
    Contact updatedContact = contact;
    updatedContact.emails.remove(email);
    BlocProvider.of<ContactsBloc>(context).add(UpdateContact(updatedContact));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Email deleted!", style: StaticVisual.error),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            updatedContact.emails.add(email);
            BlocProvider.of<ContactsBloc>(context).add(UpdateContact(updatedContact));
          },
        ),
      ),
    );
  }

  showProfilePicture(bool haveImage, Contact contact) {
    if (!haveImage) {
      return;
    } else {
      return showDialog(
        context: context,
        builder: (ctx) => Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Theme.of(context).colorScheme.background.withOpacity(0.24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(),
                ),
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(MediaQuery.of(ctx).size.width / 2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.32),
                            blurRadius: 8,
                            spreadRadius: 4,
                            offset: const Offset(0, 0),
                          )
                        ]),
                    child: BlocBuilder<ContactsBloc, ContactsState>(
                      builder: (context, state) {
                        if (state is ContactFound) {
                          return CircleAvatar(
                            foregroundImage: MemoryImage(state.contact.photoOrThumbnail!),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: CustomIconButton(
                      onPressed: () => showImageOption(contact),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      iconData: Icons.camera_alt,
                      color: Theme.of(context).colorScheme.background,
                      size: 32,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  showImageOption(Contact contact) {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Contact Photo",
                  style: TextStyle(color: Colors.white),
                  textScaleFactor: 1.1,
                ),
                CustomIconButton(
                  iconData: Icons.delete,
                  color: Colors.red,
                  onPressed: () => removeImage(contact),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomIconButton(
                  iconData: Icons.camera_alt,
                  color: Colors.white,
                  onPressed: () {
                    choseNewImage(ImageSource.camera, contact);
                  },
                ),
                CustomIconButton(
                  iconData: Icons.photo_library_rounded,
                  color: Colors.white,
                  onPressed: () {
                    choseNewImage(ImageSource.gallery, contact);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  removeImage(Contact contact) async {
    bool conformed = await confirmDelete(context, "Are you sure you want remove contact photo?");
    if (conformed) {
      Contact updatedContact = contact;
      final photo = contact.photo;
      final thumbnail = contact.thumbnail;
      updatedContact.photo = null;
      updatedContact.thumbnail = null;
      BlocProvider.of<ContactsBloc>(context).add(UpdateContact(updatedContact));

      Navigator.pop(context);
      Navigator.pop(context);
      SnackBar(
        content: Text("Photo removed!", style: StaticVisual.error),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            updatedContact.photo = photo;
            updatedContact.thumbnail = thumbnail;
            BlocProvider.of<ContactsBloc>(context).add(UpdateContact(contact));
          },
        ),
      );
    }
  }

  Future<void> choseNewImage(ImageSource source, Contact contact) async {
    XFile? image = await pickImage(source);
    if (image != null) {
      File? croppedImage = await cropImage(File(image.path), context);
      if (croppedImage != null) {
        final Uint8List bytes = await croppedImage.readAsBytes();
        contact.photo = bytes;
        BlocProvider.of<ContactsBloc>(context).add(UpdateContact(contact));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Contact photo updated", style: StaticVisual.error),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
