import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:himo/ui/global/contacts/bloc/contacts_bloc.dart';
import 'package:himo/ui/global/static_visual.dart';
import 'package:himo/ui/global/string_extension.dart';
import 'package:himo/ui/tabs/contacts/contact.dart';

import '../../global/contact/bloc/contact_bloc.dart';
import '../../global/tab.dart';
import '../../global/utils.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final TextEditingController _searchController = TextEditingController();
  bool searching = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContactsBloc>(context).add(const InitializeContact());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return MyTab(
      title: "Contacts",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: _searchController,
              onChanged: (value) {
                BlocProvider.of<ContactsBloc>(context).add(SearchContact(value));
                setState(() {
                  searching = value.isNotEmpty;
                });
              },
              cursorWidth: 1,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: 'Search Contact',
                suffixIcon: TextButton(
                    onPressed: () {
                      _searchController.clear();
                      BlocProvider.of<ContactsBloc>(context).add(const SearchContact(""));
                      setState(() {
                        searching = false;
                      });
                    },
                    child: searching ? const Icon(Icons.close) : const Icon(Icons.search)),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ContactsBloc, ContactsState>(
              builder: (context, state) {
                if (state is NoContactFound) {
                  if (state.filteredContacts.isNotEmpty) {
                    return getContactListView(context, state.filteredContacts);
                  } else {
                    return Center(
                        child: Text("No Contact Found!",
                            style: TextStyle(color: Theme
                                .of(context)
                                .colorScheme
                                .onBackground)));
                  }
                } else if (state is ContactsInitialized) {
                  if (state.filteredContacts.isNotEmpty) {
                    return getContactListView(context, state.filteredContacts);
                  } else {
                    return getContactListView(context, state.contacts);
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            StaticVisual.mediumWidth,
            const Icon(
              Icons.call,
              color: Colors.white,
            ),
            StaticVisual.smallWidth,
            const Text(
              "Call",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slidLeftBackground() {
    return Container(
      color: Colors.orange,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Icon(
              Icons.message,
              color: Colors.white,
            ),
            StaticVisual.smallWidth,
            const Text(
              "Message",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            StaticVisual.mediumWidth
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget getContactListView(BuildContext context, Iterable<Contact> contacts) {
    return RefreshIndicator(
      onRefresh: refreshContacts,
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          Contact _contact = contacts.elementAt(index);
          return Dismissible(
            key: Key(_contact.id),
            background: slideRightBackground(),
            secondaryBackground: slidLeftBackground(),
            confirmDismiss: (direction) async {
              final bool res = await getNumbersDialog(direction, index, contacts);
              return res;
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              leading: (_contact.photoOrThumbnail != null && _contact.photoOrThumbnail!.isNotEmpty)
                  ? CircleAvatar(backgroundImage: MemoryImage(_contact.photoOrThumbnail!))
                  : CircleAvatar(
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                child: Text(
                  _contact.displayName.initials(),
                  textScaleFactor: 1.2,
                ),
              ),
              title: Text(_contact.displayName),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ContactDetails(contactId: _contact.id)));
              },
            ),
          );
        },
      ),
    );
  }

  void resetSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> refreshContacts() async {
    resetSearch();
    BlocProvider.of<ContactsBloc>(context).add(const RefreshContacts());
  }

  Future<bool> getNumbersDialog(direction, int index, Iterable<Contact> contacts) async {

    Contact contact = contacts.toList()[index];
    BlocProvider.of<ContactBloc>(context).add(GetContact(contact.id));

    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                direction == DismissDirection.endToStart ? "Send Message to ${contact.displayName}" : "Call to ${contact
                    .displayName}"),
            content: BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                if (state is ContactFound) {
                  if (state.contact.phones.length == 1) {
                    if (direction == DismissDirection.endToStart) {
                      sendSMS(message: "", recipients: [state.contact.phones[0].number]);
                    } else {
                      callNumber(state.contact.phones[0].number);
                    }
                    Navigator.of(context).pop();
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        children: state.contact.phones
                            .map((e) =>
                            ListTile(
                                onTap: () {
                                  direction == DismissDirection.endToStart ? sendSMS(
                                      message: "", recipients: [state.contact.phones[0].number]) : callNumber(
                                      state.contact.phones[0].number);
                                },
                                title: Text(e.number),
                                leading: Icon(
                                  e.label.name == "work" ? Icons.work_outline : Icons.home_outlined,
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .secondary,
                                )))
                            .toList(),
                      ),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container();
              },
            ),
          );
        }) ??
        false;
  }
}
