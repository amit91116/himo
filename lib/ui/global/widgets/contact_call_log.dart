import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:himo/models/call_log.dart';
import 'package:himo/ui/global/static_visual.dart';
import 'package:himo/ui/tabs/contacts/contact_logs.dart';

class ContactCallLog extends StatelessWidget {
  final HimoCallLog logs;
  final EdgeInsetsGeometry? margin;
  final Contact contact;

  const ContactCallLog({Key? key, required this.contact, required this.logs, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxWidth = StaticVisual.usableWidth(context);
    final double width = (3 * maxWidth / 10).floorToDouble() - 8;
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ContactLogs(contact: contact, logs: logs))),
      child: Container(
        width: width,
        height: width,
        margin: margin,
        decoration: StaticVisual.boxDecoration(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${logs.count}",
                  textScaleFactor: 3,
                  style: TextStyle(color: logs.color),
                ),
                Icon(logs.icon, size: width / 3, color: logs.color)
              ],
            ),
            Visibility(
              visible: logs.formattedDuration != "00:00:00",
              child: Text(
                "Duration: ${logs.formattedDuration}",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
