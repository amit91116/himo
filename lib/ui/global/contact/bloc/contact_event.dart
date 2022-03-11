part of 'contact_bloc.dart';

@immutable
class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

class GetContact extends ContactEvent {
  final String contactId;

  const GetContact(this.contactId) : super();

  @override
  List<Object?> get props => [];
}

class UpdateContact extends ContactEvent {
  final Contact updatedContact;
  const UpdateContact(this.updatedContact): super();
  @override
  List<Object?> get props => [];
}