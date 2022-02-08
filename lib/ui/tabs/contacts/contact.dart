import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:himo/ui/global/constants.dart';
import 'package:himo/ui/global/static_visual.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = StaticVisual.usableWidth(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: maxWidth,
            height: 290,
            child: getProfileStatic(maxWidth),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
    if (output == "" && contact.phones != null && contact.phones!.isNotEmpty) output = contact.phones![0].value ?? "";
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
              boxShadow: [
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
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(58), bottomLeft: Radius.circular(58)),
              boxShadow: [
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
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.all(Radius.circular(58)),
            ),
            child: (widget.contact.avatar != null && widget.contact.avatar!.isNotEmpty)
                ? CircleAvatar(
                    backgroundImage: MemoryImage(widget.contact.avatar!),
                  )
                : CircleAvatar(
                    child: Icon(Icons.account_circle, size: 64),
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
                  TextButton(onPressed: () => _callNumber(primaryPhone), child: Icon(Icons.call)),
                  StaticVisual.smallWidth,
                  TextButton(
                      onPressed: () => {
                            sendSMS(message: "", recipients: [primaryPhone])
                          },
                      child: Icon(Icons.message)),
                  Visibility(visible: (widget.contact.emails != null && widget.contact.emails!.isNotEmpty), child: StaticVisual.smallWidth),
                  Visibility(
                    visible: (widget.contact.emails != null && widget.contact.emails!.isNotEmpty),
                    child: TextButton(
                        onPressed: (widget.contact.emails != null && widget.contact.emails!.isNotEmpty)
                            ? () => {_sendEmail(widget.contact.emails![0].value!)}
                            : null,
                        child: Icon(Icons.email)),
                  ),
                  StaticVisual.smallWidth,
                  TextButton(onPressed: () => launch("whatsapp://send?phone=${primaryPhone}"), child: Constants.whatsAppIcon),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column getPhoneNumbers() {
    if (widget.contact.phones == null) return Column();
    Set<String> phones = Set<String>();
    List<Item> items = widget.contact.phones!.where((element) => phones.add(element.value!)).toList();
    return Column(
        children: items
            .map(
              (phone) => ListTile(
                leading: Icon(
                  phone.label == "work" ? Icons.work_outline : Icons.home_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(phone.value!),
                trailing: TextButton(onPressed: () => _callNumber(phone.value!), child: Icon(Icons.call_outlined)),
              ),
            )
            .toList());
  }

  Column getEmails() {
    if (widget.contact.emails == null) return Column();
    Set<String> emails = Set<String>();
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
                trailing: TextButton(onPressed: () => {_sendEmail(email.value!)}, child: Icon(Icons.email_outlined)),
              ),
            )
            .toList());
  }

  Widget getHeading(String heading) {
    return Container(
      padding: EdgeInsets.only(left: 20),
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
    launch("mailto:${email}");
  }
}
