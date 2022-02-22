import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

part 'contacts_event.dart';

part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  static bool isContactLoaded = false;

  ContactsBloc() : super(const ContactsState(Iterable<Contact>.empty(), Iterable<Contact>.empty())) {
    on<InitializeContact>((event, emit) async {
      late Iterable<Contact> contacts;
      if (await FlutterContacts.requestPermission()) {
        if (state is ContactsInitialized && isContactLoaded) {
          contacts = state.contacts;
        } else if (!isContactLoaded) {
          isContactLoaded = true;
          contacts = await FlutterContacts.getContacts(withAccounts: true, withPhoto: true);
        } else {
          return;
        }
        emit.call(ContactsInitialized(contacts, const Iterable<Contact>.empty()));
      }
    });

    on<GetContact>((event, emit) async {
      Contact? contact = await FlutterContacts.getContact(event.contactId,
          withPhoto: true, withAccounts: true, deduplicateProperties: true, withGroups: true, withProperties: true, withThumbnail: true);
      if (contact != null) {
        emit.call(ContactFound(contact, state.contacts, const Iterable<Contact>.empty()));
      }
    });

    on<RefreshContacts>((event, emit) async {
      emit.call(const ContactLoading(Iterable<Contact>.empty(), Iterable<Contact>.empty()));
      isContactLoaded = true;
      Iterable<Contact> contacts = await FlutterContacts.getContacts();
      emit.call(ContactsInitialized(contacts, const Iterable<Contact>.empty()));
    });

    on<SearchContact>((event, emit) async {
      late Iterable<Contact> contacts;
      late Iterable<Contact> filteredContacts;
      if (state is ContactsInitialized) {
        contacts = state.contacts;
      } else {
        contacts = await FlutterContacts.getContacts();
      }
      emit.call(ContactLoading(contacts, const Iterable<Contact>.empty()));
      if (event.searchContact.isNotEmpty) {
        List<Contact> fContacts = <Contact>[];
        fContacts.addAll(contacts);
        fContacts.retainWhere((element) {
          return (element.displayName.toLowerCase().contains(event.searchContact.trim().toLowerCase())) ||
              (element.phones.where((element) => element.number.contains(event.searchContact.trim())).isNotEmpty);
        });
        filteredContacts = fContacts;
        if (fContacts.isEmpty) {
          emit.call(NoContactFound(contacts, filteredContacts));
        } else {
          emit.call(ContactsInitialized(contacts, filteredContacts));
        }
      } else {
        filteredContacts = const Iterable<Contact>.empty();
        emit.call(ContactsInitialized(contacts, filteredContacts));
      }
    });
  }
}
