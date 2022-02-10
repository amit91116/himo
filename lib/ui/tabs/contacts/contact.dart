import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:himo/ui/global/call_logs/bloc/call_logs_bloc.dart';
import 'package:himo/ui/global/constants.dart';
import 'package:himo/ui/global/static_visual.dart';
import 'package:himo/ui/tabs/call_logs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';

import '../../global/utils.dart';

class ContactDetails extends StatefulWidget {
  final Contact contact;

  const ContactDetails({Key? key, required this.contact}) : super(key: key);

  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  late final String fullName;
  late final String primaryPhone;

  @override
  void initState() {
    super.initState();
    setState(() => fullName = getFullName(widget.contact));
    setState(() => primaryPhone = getPrimaryPhone(widget.contact));
    if (fullName.isNotEmpty && primaryPhone != fullName) {
      BlocProvider.of<CallLogsBloc>(context).add(LoadCallLogsForContactByName(widget.contact.displayName!));
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
                      return const CircularProgressIndicator();
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
    return output.toUpperCase();
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
            child: (widget.contact.avatar != null && widget.contact.avatar!.isNotEmpty)
                ? CircleAvatar(
                    backgroundImage: MemoryImage(widget.contact.avatar!),
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
                visible: (fullName != primaryPhone && widget.contact.phones!.isNotEmpty),
                child: Text(
                  (fullName != primaryPhone && widget.contact.phones!.isNotEmpty) ? widget.contact.phones![0].value! : "",
                  textScaleFactor: 1,
                ),
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
                  Visibility(visible: (widget.contact.emails != null && widget.contact.emails!.isNotEmpty), child: StaticVisual.smallWidth),
                  Visibility(
                    visible: (widget.contact.emails != null && widget.contact.emails!.isNotEmpty),
                    child: TextButton(
                        onPressed: (widget.contact.emails != null && widget.contact.emails!.isNotEmpty)
                            ? () => {_sendEmail(widget.contact.emails![0].value!)}
                            : null,
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
    if (widget.contact.phones == null || widget.contact.phones!.isEmpty) {
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
    List<Item> items = widget.contact.phones!.where((element) => phones.add(removeSpaces(element.value!))).toList();
    return Column(
        children: items
            .map(
              (phone) => ListTile(
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
            )
            .toList());
  }

  Column getEmails() {
    if (widget.contact.emails == null || widget.contact.emails!.isEmpty) {
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
    List<Item> items = widget.contact.emails!.where((element) => emails.add(element.value!)).toList();
    return Column(
        children: items
            .map(
              (email) => ListTile(
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
      height: 100,
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(16), child: Text("Incomming Calls: ${logs.incommingCalls.count}")),
          Container(padding: const EdgeInsets.all(16), child: Text("Outgoing Calls: ${logs.outgoingCalls.count}")),
          Container(padding: const EdgeInsets.all(16), child: Text("Missed Calls: ${logs.missedCalls.count}")),
        ],
      ),
    );
  }
}
