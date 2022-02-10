part of 'call_logs_bloc.dart';

@immutable
class CallLogsEvent extends Equatable {
  const CallLogsEvent();

  @override
  List<Object> get props => [];
}

class LoadCallLogsForContactByName extends CallLogsEvent {
  final String name;
  const LoadCallLogsForContactByName(this.name) : super();
}
