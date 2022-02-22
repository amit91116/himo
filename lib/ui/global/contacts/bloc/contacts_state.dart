part of 'contacts_bloc.dart';

@immutable
class ContactsState extends Equatable {
  final Iterable<Contact> contacts;
  final Iterable<Contact> filteredContacts;

  const ContactsState(this.contacts, this.filteredContacts);

  @override
  // TODO: implement props
  List<Object?> get props => [contacts];
}

class ContactLoading extends ContactsState {
  const ContactLoading(contacts, filteredContacts) : super(contacts, filteredContacts);

  @override
  List<Object> get props => [contacts];
}

class ContactsInitialized extends ContactsState {
  const ContactsInitialized(contacts, filteredContacts) : super(contacts, filteredContacts);

  @override
  List<Object> get props => [contacts];
}

class NoContactFound extends ContactsInitialized {
  const NoContactFound(contacts, filteredContacts) : super(contacts, filteredContacts);

  @override
  List<Object> get props => [contacts];
}

class ContactFound extends ContactsInitialized {
  final Contact contact;
  const ContactFound(this.contact, contacts, filteredContacts) : super(contacts, filteredContacts);

  @override
  List<Object> get props => [contacts];
}

