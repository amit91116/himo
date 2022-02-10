import 'package:bloc/bloc.dart';
import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:himo/models/call_log.dart';

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
      HimoCallLog incommingLogs = HimoCallLog(incomingCalls);
      HimoCallLog outgoingLogs = HimoCallLog(outgoingCalls);
      HimoCallLog missedLogs = HimoCallLog(missedCalls);

      emit.call(CallLogsLoaded(incommingLogs, outgoingLogs, missedLogs));
    });
  }
}
