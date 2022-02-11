import 'package:flutter/material.dart';
import 'package:himo/models/call_log.dart';
import 'package:himo/ui/global/static_visual.dart';

class ContactCallLog extends StatelessWidget {
  final HimoCallLog logs;
  final EdgeInsetsGeometry? margin;
  const ContactCallLog({Key? key, required this.logs, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxWidth = StaticVisual.usableWidth(context);
    final double width = (3 * maxWidth / 10).floorToDouble() - 8;
    return Container(
      width: width,
      height: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: logs.color.withOpacity(0.16),
            offset: const Offset(0, 0),
            blurRadius: 2,
            spreadRadius: 2,
          )
        ],
        color: logs.color.withOpacity(0.08),
      ),
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
    );
  }
}
