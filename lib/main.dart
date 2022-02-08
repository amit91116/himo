import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:himo/ui/global/contacts/bloc/contacts_bloc.dart';
import 'package:himo/ui/global/permissions/bloc/permissions_bloc.dart';
import 'package:himo/ui/global/theme/bloc/theme_bloc.dart';
import 'package:himo/ui/intro/intro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (BuildContext context) => ThemeBloc(),
        ),
        BlocProvider<PermissionBloc>(
          create: (BuildContext context) => PermissionBloc(),
        ),
        BlocProvider<ContactsBloc>(
          create: (BuildContext context) => ContactsBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'HIMO',
            theme: state.themeData,
            debugShowCheckedModeBanner: false,
            home: const Intro(),
          );
        },
      ),
    );
  }
}
