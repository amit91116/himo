import 'package:call_log/call_log.dart';

class HimoCallLog {
  List<CallLogEntry> entries = List.empty();
  int duration = 0;
  int count = 0;
  late String formattedDuration;
  HimoCallLog(Iterable<CallLogEntry> entriesItrator) {
    entries = entriesItrator.toList();
    for (var element in entries) {
      duration += element.duration ?? 0;
    }
    var h = (duration / 3600).floor();
    var m = (duration % 3600 / 60).floor();
    var s = (duration % 3600 % 60).floor();
    formattedDuration = "$h:$m:$s";
    count = entries.length;
  }
}
