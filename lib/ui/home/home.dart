import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../global/constants.dart';
import '../global/contacts/bloc/contacts_bloc.dart';
import '../tabs/call_logs.dart';
import '../tabs/contacts/contacts.dart';
import '../tabs/dashboard.dart';
import '../tabs/settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int tabIndex = 0;

  final List<Widget> tabs = const <Widget>[Dashboard(), CallLogs(), Contacts(), Settings()];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContactsBloc>(context).add(const InitializeContact());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs.elementAt(tabIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        color: Theme.of(context).colorScheme.primary,
        height: Constants.navHeight,
        animationDuration: const Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.dashboard, size: 24, color: Theme.of(context).colorScheme.background),
          Icon(Icons.phone_callback, size: 24, color: Theme.of(context).colorScheme.background),
          Icon(Icons.contacts, size: 24, color: Theme.of(context).colorScheme.background),
          Icon(Icons.settings, size: 24, color: Theme.of(context).colorScheme.background),
        ],
        onTap: (index) => index != tabIndex
            ? setState(() {
                tabIndex = index;
              })
            : null,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
