import 'dart:async';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:himo/models/call_log.dart';
import 'package:himo/ui/global/string_extension.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/constants.dart';
import '../../global/static_visual.dart';
import '../../global/utils.dart';

class ContactLogs extends StatefulWidget {
  final HimoCallLog logs;
  final Contact contact;

  const ContactLogs({Key? key, required this.contact, required this.logs}) : super(key: key);

  @override
  State<ContactLogs> createState() => _ContactLogsState();
}

class _ContactLogsState extends State<ContactLogs> {
  bool hasMultiplePhones = false;
  bool showFilter = true;

  @override
  void initState() {
    super.initState();
    hasMultiplePhones = widget.contact.phones.length > 1;
    Timer(const Duration(seconds: 3), () {
      setState(() {
        showFilter = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = StaticVisual.usableWidth(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 32, bottom: 16),
            width: maxWidth,
            height: 116,
            child: getProfileStatic(widget.contact, maxWidth),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        showFilter = !showFilter;
                      });
                    },
                    icon: const Icon(Icons.calendar_today)),
                Text(
                  "Duration: ${widget.logs.formattedDuration}",
                  textScaleFactor: 1.3,
                ),
              ],
            ),
          ),
          Visibility(
            child: TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime(1970),
              lastDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
            ),
            visible: showFilter,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.logs.count,
              itemBuilder: (context, index) {
                CallLogEntry log = widget.logs.entries[index];
                DateTime dateTime = getDateTime(log.timestamp!);
                bool _isBefore = true;
                if (index > 0) _isBefore = isBefore(widget.logs.entries[index - 1], dateTime);
                String timestamp = getTimeFormat().format(dateTime);

                ListTile tile;

                if (hasMultiplePhones) {
                  tile = ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(log.number!),
                        Text(timestamp),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: getWidth(maxWidth, widget.logs.duration, log.duration),
                          height: 16,
                          decoration: BoxDecoration(
                              color: widget.logs.lightColor,
                              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
                        ),
                        Text(formatDuration(log.duration!)),
                      ],
                    ),
                  );
                } else {
                  tile = ListTile(
                    title: Text(timestamp),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: getWidth(maxWidth, widget.logs.duration, log.duration),
                          height: 16,
                          decoration: BoxDecoration(
                              color: widget.logs.lightColor,
                              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
                        ),
                        Text(formatDuration(log.duration!)),
                      ],
                    ),
                  );
                }
                if (_isBefore) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          getDateFormat().format(dateTime),
                          textScaleFactor: 1.3,
                        ),
                      ),
                      tile,
                    ],
                  );
                }
                return tile;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getProfileStatic(Contact contact, double maxWidth) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Container(
            width: 116,
            height: 116,
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(58)),
            ),
            child: (contact.thumbnail != null)
                ? CircleAvatar(
                    backgroundImage: MemoryImage(contact.photoOrThumbnail!),
                  )
                : CircleAvatar(
                    child: Text(
                      getFullName(contact).initials(),
                      textScaleFactor: 3.5,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StaticVisual.smallHeight,
              Row(
                children: [
                  Text(getFullName(contact), textScaleFactor: 2),
                  Icon(widget.logs.icon, color: widget.logs.color)
                ],
              ),
              StaticVisual.smallHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: () => callNumber(getPrimaryPhone(contact)),
                      child: const Icon(
                        Icons.call,
                        color: Colors.green,
                      )),
                  TextButton(
                      onPressed: () => {
                            sendSMS(message: "", recipients: [getPrimaryPhone(contact)])
                          },
                      child: const Icon(
                        Icons.message,
                        color: Colors.orange,
                      )),
                  Visibility(
                    visible: (contact.emails.isNotEmpty),
                    child: TextButton(
                        onPressed: (contact.emails.isNotEmpty) ? () => {sendEmail(contact.emails[0].address)} : null,
                        child: const Icon(Icons.email)),
                  ),
                  TextButton(
                      onPressed: () => launch("whatsapp://send?phone=${getPrimaryPhone(contact)}"),
                      child: Constants.whatsAppIcon),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
