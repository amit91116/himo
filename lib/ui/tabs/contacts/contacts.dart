import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:himo/ui/global/contacts/bloc/contacts_bloc.dart';
import 'package:himo/ui/global/string_extension.dart';
import 'package:himo/ui/tabs/contacts/contact.dart';

import '../../global/tab.dart';

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
          SizedBox(
            width: size.width,
            height: 56,
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
                    return Center(child: Text("No Contact Found!", style: TextStyle(color: Theme
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

  Widget getContactListView(BuildContext context, Iterable<Contact> contacts) {
    return RefreshIndicator(
      onRefresh: refreshContacts,
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          Contact _contact = contacts.elementAt(index);
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            leading: (_contact.photoOrThumbnail != null && _contact.photoOrThumbnail!.isNotEmpty)
                ? CircleAvatar(backgroundImage: MemoryImage(_contact.photoOrThumbnail!))
                : CircleAvatar(
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .primary,
              child: Text(_contact.displayName.initials(), textScaleFactor: 1.2,),
            ),
            title: Text(_contact.displayName),
            onTap: () {
              _searchController.clear();
              FocusScope.of(context).unfocus();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ContactDetails(contactId: _contact.id)));
            },
          );
        },
      ),
    );
  }

  Future<void> refreshContacts() async {
    BlocProvider.of<ContactsBloc>(context).add(const RefreshContacts());
  }
}
