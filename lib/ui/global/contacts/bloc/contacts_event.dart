part of 'contacts_bloc.dart';

@immutable
class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object?> get props => [];
}

class InitializeContact extends ContactsEvent {
  const InitializeContact() : super();

  @override
  List<Object?> get props => [];
}

class SearchContact extends ContactsEvent {
  final String searchContact;

  const SearchContact(this.searchContact) : super();

  @override
  List<Object?> get props => [];
}
