import 'package:bloc/bloc.dart';
import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himo/models/call_log.dart';
import 'package:himo/ui/global/static_visual.dart';

part 'call_logs_event.dart';
part 'call_logs_state.dart';

class CallLogsBloc extends Bloc<CallLogsEvent, CallLogsState> {
  CallLogsBloc() : super(const CallLogsState()) {
    on<LoadCallLogsForContactByName>((event, emit) async {
      emit.call(const CallLogsLoading());
      String name = event.name;
      Iterable<CallLogEntry> incomingCalls = await CallLog.query(
        name: name,
        type: CallType.incoming,
      );
      Iterable<CallLogEntry> outgoingCalls = await CallLog.query(
        name: name,
        type: CallType.outgoing,
      );
      Iterable<CallLogEntry> missedCalls = await CallLog.query(
        name: name,
        type: CallType.missed,
      );
      HimoCallLog incommingLogs = HimoCallLog(incomingCalls, CallType.incoming, Icons.call_received, StaticVisual.incomingColor);
      HimoCallLog outgoingLogs = HimoCallLog(outgoingCalls, CallType.outgoing, Icons.call_made, StaticVisual.outgoingColor);
      HimoCallLog missedLogs = HimoCallLog(missedCalls, CallType.missed, Icons.call_missed, StaticVisual.missedColor);

      emit.call(CallLogsLoaded(incommingLogs, outgoingLogs, missedLogs));
    });
  }
}
