part of 'contact_bloc.dart';

abstract class ContactState extends Equatable {
  const ContactState();
}

class ContactInitial extends ContactState {
  @override
  List<Object> get props => [];
}

class ContactLoading extends ContactState {
  @override
  List<Object> get props => [];
}

class ContactFound extends ContactState {
  final Contact contact;

  const ContactFound(this.contact) : super();

  @override
  List<Object?> get props => [contact];
}
