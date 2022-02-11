import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'contacts_event.dart';

part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  static bool isContactLoaded = false;

  ContactsBloc() : super(const ContactsState(Iterable<Contact>.empty(), Iterable<Contact>.empty())) {
    on<InitializeContact>((event, emit) async {
      late Iterable<Contact> contacts;
      if (state is ContactsInitialized && isContactLoaded) {
        contacts = state.contacts;
      } else {
        isContactLoaded = true;
        contacts = await ContactsService.getContacts();
      }
      emit.call(ContactsInitialized(contacts, const Iterable<Contact>.empty()));
    });

    on<RefreshContacts>((event, emit) async {
      emit.call(const ContactLoading(Iterable<Contact>.empty(), Iterable<Contact>.empty()));
      isContactLoaded = true;
      Iterable<Contact> contacts = await ContactsService.getContacts();
      emit.call(ContactsInitialized(contacts, const Iterable<Contact>.empty()));
    });

    on<SearchContact>((event, emit) async {
      late Iterable<Contact> contacts;
      late Iterable<Contact> filteredContacts;
      if (state is ContactsInitialized) {
        contacts = state.contacts;
      } else {
        contacts = await ContactsService.getContacts();
      }
      emit.call(ContactLoading(contacts, const Iterable<Contact>.empty()));
      if (event.searchContact.isNotEmpty) {
        List<Contact> fContacts = <Contact>[];
        fContacts.addAll(contacts);
        fContacts.retainWhere((element) {
          return (element.displayName != null && element.displayName!.toLowerCase().contains(event.searchContact.trim().toLowerCase())) ||
              (element.phones != null &&
                  element.phones!.where((element) => element.value!.contains(event.searchContact.trim())).isNotEmpty);
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
