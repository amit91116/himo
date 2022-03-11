import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

part 'contact_event.dart';

part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial()) {
    on<GetContact>((event, emit) async {
      emit.call(ContactLoading());
      Contact? contact = await FlutterContacts.getContact(
        event.contactId,
        withPhoto: true,
        withAccounts: true,
        deduplicateProperties: true,
        withGroups: true,
        withProperties: true,
        withThumbnail: true,
      );
      if (contact != null) {
        emit.call(ContactFound(contact));
      }
    });

    on<UpdateContact>((event, emit) async {
      emit.call(ContactLoading());
      Contact contact = await FlutterContacts.updateContact(event.updatedContact);
      emit.call(ContactFound(contact));
    });
  }
}
