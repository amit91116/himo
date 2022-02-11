import 'package:call_log/call_log.dart';
import 'package:flutter/cupertino.dart';

class HimoCallLog {
  List<CallLogEntry> entries = List.empty();
  int duration = 0;
  int count = 0;
  late String formattedDuration;
  late CallType type;
  late IconData icon;
  late Color color;
  HimoCallLog(Iterable<CallLogEntry> entriesItrator, this.type, this.icon, this.color) {
    entries = entriesItrator.toList();
    for (var element in entries) {
      duration += element.duration ?? 0;
    }
    var h = (duration / 3600).floor();
    var m = (duration % 3600 / 60).floor();
    var s = (duration % 3600 % 60).floor();
    formattedDuration = "${h < 10 ? '0$h' : h}:${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";
    count = entries.length;
  }
}
