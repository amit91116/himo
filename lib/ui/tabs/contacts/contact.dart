import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:himo/ui/global/call_logs/bloc/call_logs_bloc.dart';
import 'package:himo/ui/global/constants.dart';
import 'package:himo/ui/global/static_visual.dart';
import 'package:himo/ui/global/widgets/contact_call_log.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/utils.dart';

class ContactDetails extends StatefulWidget {
  final Contact contact;

  const ContactDetails({Key? key, required this.contact}) : super(key: key);

  @override
  _ContactDetailsState createState() => _ContactDetailsState(contact);
}

class _ContactDetailsState extends State<ContactDetails> {
  late final String fullName;
  late final String primaryPhone;
  Contact contact;

  _ContactDetailsState(this.contact);

  @override
  void initState() {
    super.initState();
    setState(() => fullName = getFullName(contact));
    setState(() => primaryPhone = getPrimaryPhone(contact));
    if (fullName.isNotEmpty && primaryPhone != fullName) {
      BlocProvider.of<CallLogsBloc>(context).add(LoadCallLogsForContactByName(contact.displayName!));
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = StaticVisual.usableWidth(context);
    return Scaffold(

      body: Column(
        children: [
          SizedBox(
            width: maxWidth,
            height: 290,
            child: getProfileStatic(maxWidth),
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
                  getHeading("Mobiles"),
                  getPhoneNumbers(),
                  getHeading("Emails"),
                  getEmails(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getFullName(Contact contact) {
    String output = "";
    output += contact.prefix ?? "";
    output += contact.displayName ?? "";
    output += contact.suffix ?? "";
    if (output == "" && contact.phones != null && contact.phones!.isNotEmpty) {
      output = contact.phones![0].value ?? "";
    }
    return output;
  }

  String getPrimaryPhone(Contact contact) {
    return (contact.phones != null && contact.phones!.isNotEmpty) ? contact.phones![0].value! : "";
  }

  Widget getProfileStatic(double maxWidth) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: maxWidth,
            height: 108,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(maxWidth / 2), bottomRight: Radius.circular(maxWidth / 2)),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.32),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 5,
                )
              ],
            ),
          ),
        ),
        Positioned(
            left: 0,
            top: 8,
            child: TextButton(
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.background,
              ),
              onPressed: () => Navigator.pop(context),
            )),
        Positioned(
          left: maxWidth / 2 - 54,
          top: 108,
          width: 108,
          height: 54,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(58), bottomLeft: Radius.circular(58)),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 5,
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: maxWidth / 2 - 54,
          top: 54,
          width: 108,
          height: 108,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(58)),
            ),
            child: (contact.avatar != null && contact.avatar!.isNotEmpty)
                ? CircleAvatar(
                    backgroundImage: MemoryImage(contact.avatar!),
                  )
                : CircleAvatar(
                    child: const Icon(Icons.account_circle, size: 64),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
          ),
        ),
        Positioned(
          top: 166,
          width: maxWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StaticVisual.smallHeight,
              Text(fullName, textScaleFactor: 2),
              Visibility(
                visible: (fullName != primaryPhone && contact.phones!.isNotEmpty),
                child: Text(
                  (fullName != primaryPhone && contact.phones!.isNotEmpty) ? contact.phones![0].value! : "",
                  textScaleFactor: 1,
                ),
              ),
              Visibility(
                visible: contact.birthday != null,
                child: Text(contact.birthday.toString()),
              ),
              StaticVisual.smallHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(onPressed: () => _callNumber(primaryPhone), child: const Icon(Icons.call)),
                  StaticVisual.smallWidth,
                  TextButton(
                      onPressed: () => {
                            sendSMS(message: "", recipients: [primaryPhone])
                          },
                      child: const Icon(Icons.message)),
                  Visibility(visible: (contact.emails != null && contact.emails!.isNotEmpty), child: StaticVisual.smallWidth),
                  Visibility(
                    visible: (contact.emails != null && contact.emails!.isNotEmpty),
                    child: TextButton(
                        onPressed:
                            (contact.emails != null && contact.emails!.isNotEmpty) ? () => {_sendEmail(contact.emails![0].value!)} : null,
                        child: const Icon(Icons.email)),
                  ),
                  StaticVisual.smallWidth,
                  TextButton(onPressed: () => launch("whatsapp://send?phone=$primaryPhone"), child: Constants.whatsAppIcon),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column getPhoneNumbers() {
    if (contact.phones == null || contact.phones!.isEmpty) {
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
    List<Item> items = contact.phones!.where((element) => phones.add(removeSpaces(element.value!))).toList();
    return Column(
        children: items
            .map(
              (phone) => Slidable(
                key: Key(phone.value!),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => {
                        sendSMS(message: "", recipients: [phone.value!])
                      },
                      backgroundColor: const Color(0xFFF86B00),
                      foregroundColor: Theme.of(context).colorScheme.background,
                      icon: Icons.message_outlined,
                      label: 'Message',
                    ),
                    SlidableAction(
                      onPressed: (context) => {launch("whatsapp://send?phone=${phone.value}")},
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
                    phone.label == "work" ? Icons.work_outline : Icons.home_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(phone.value!),
                  trailing: TextButton(onPressed: () => _callNumber(phone.value!), child: const Icon(Icons.call_outlined)),
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: phone.value!));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied!")));
                  },
                  onTap: () => launch("tel://${phone.value!}"),
                ),
              ),
            )
            .toList());
  }

  Column getEmails() {
    if (contact.emails == null || contact.emails!.isEmpty) {
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
    List<Item> items = contact.emails!.where((element) => emails.add(element.value!)).toList();
    return Column(
        children: items
            .map(
              (email) => Slidable(
                key: Key(email.value!),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => {_sendEmail(email.value!)},
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.background,
                      icon: Icons.send,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    email.label == "work" ? Icons.work_outline : Icons.home_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(email.value!),
                  trailing: TextButton(onPressed: () => {_sendEmail(email.value!)}, child: const Icon(Icons.email_outlined)),
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: email.value!));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied!")));
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

  // This feature is not yet supported by Contact Services
  deletePhoneNumber(BuildContext context, Item phone) async {
    Contact updatedContact = contact;
    updatedContact.phones!.remove(phone);
    await ContactsService.deleteContact(contact);
    await ContactsService.addContact(updatedContact);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Phone deleted!", style: StaticVisual.error),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            updatedContact.phones!.add(phone);
            setState(() => contact = updatedContact);
          },
        ),
      ),
    );
    setState(() => contact = updatedContact);
  }

  // This feature is not yet supported by Contact Services
  deleteEmail(BuildContext context, Item email) {
    Contact updatedContact = contact;
    updatedContact.emails!.remove(email);
    ContactsService.updateContact(updatedContact);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Email deleted!", style: StaticVisual.error),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            updatedContact.emails!.add(email);
            setState(() => contact = updatedContact);
          },
        ),
      ),
    );
    setState(() => contact = updatedContact);
  }
}
