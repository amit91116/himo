import 'package:call_log/call_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:himo/ui/global/utils.dart';

class HimoCallLog {
  List<CallLogEntry> entries = List.empty();
  int duration = 0;
  int count = 0;
  late String formattedDuration;
  late CallType type;
  late IconData icon;
  late Color color;
  late Color lightColor;
  HimoCallLog(Iterable<CallLogEntry> entriesIterator, this.type, this.icon, this.color) {
    entries = entriesIterator.toList();
    for (var element in entries) {
      duration += element.duration ?? 0;
    }
    formattedDuration = formatDuration(duration);
    count = entries.length;
    lightColor = color.withOpacity(0.63);
  }
}
