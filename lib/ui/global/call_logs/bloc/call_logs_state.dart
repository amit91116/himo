part of 'call_logs_bloc.dart';

@immutable
class CallLogsState extends Equatable {
  const CallLogsState();

  @override
  List<Object> get props => [];
}

class CallLogsLoading extends CallLogsState {
  const CallLogsLoading() : super();
}

class CallLogsLoaded extends CallLogsState {
  final HimoCallLog incomingCalls;
  final HimoCallLog outgoingCalls;
  final HimoCallLog missedCalls;
  const CallLogsLoaded(this.incomingCalls, this.outgoingCalls, this.missedCalls) : super();
}
