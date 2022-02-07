import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../global/permissions/bloc/permissions_bloc.dart';
import '../global/static_visual.dart';
import '../global/theme/app_theme.dart';
import '../global/theme/bloc/theme_bloc.dart';
import '../home/home.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PermissionBloc>(context).add(const InitializePermission(PermissionStatus.denied, PermissionStatus.denied));
    BlocProvider.of<ThemeBloc>(context).add(const InitializeTheme(AppTheme.light));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<PermissionBloc, PermissionState>(
        listener: (context, state) {
          if (state is PermissionsApproved) {
            goToHome(context);
          }
          if (state is PermissionFailed) {
            _handleInvalidPermissions(state.contactPermission, "Contacts");
            _handleInvalidPermissions(state.phonePermission, "Call Logs");
          }
        },
        child: IntroductionScreen(
          pages: [
            PageViewModel(title: "Slide 1", body: 'This is the Body 1', decoration: getPageDecoration()),
            PageViewModel(title: "Slide 2", body: 'This is the Body 2', decoration: getPageDecoration()),
            PageViewModel(
                title: "Required Permissions",
                bodyWidget: BlocBuilder<PermissionBloc, PermissionState>(
                  builder: (context, state) {
                    bool contactPermission = state.contactPermission.isGranted;
                    bool phonePermission = state.phonePermission.isGranted;
                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Contact Permission"),
                            StaticVisual.smallWidth,
                            Icon(
                              contactPermission ? Icons.check : Icons.close,
                              color: contactPermission ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                            )
                          ],
                        ),
                        StaticVisual.smallHeight,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Call Logs Permission"),
                            StaticVisual.smallWidth,
                            Icon(
                              phonePermission ? Icons.check : Icons.close,
                              color: phonePermission ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                            )
                          ],
                        )
                      ],
                    );
                  },
                ),
                decoration: getPageDecoration()),
          ],
          done: const Text('Allow Permission', style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () => _askPermissions(context),
          showSkipButton: true,
          skip: const Text('Skip'),
          onSkip: () => _askPermissions(context),
          next: const Icon(Icons.arrow_forward),
          dotsDecorator: getDotDecoration(),
          globalBackgroundColor: Theme.of(context).colorScheme.background,
          skipFlex: 0,
          nextFlex: 0,
        ),
      ),
    );
  }

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Theme.of(context).colorScheme.secondary.withOpacity(0.32),
    activeColor: Theme.of(context).colorScheme.secondary,
    size: const Size(8, 8),
    activeSize: const Size(16, 8),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const MyHomePage()),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyTextStyle: const TextStyle(fontSize: 20),
    descriptionPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: const EdgeInsets.all(24),
    pageColor: Theme.of(context).colorScheme.background,
  );

  Future<void> _askPermissions(context) async {
    PermissionStatus contactStatus = await _getContactPermission();
    PermissionStatus phoneStatus = await _getPhonePermission();
    BlocProvider.of<PermissionBloc>(context).add(PermissionChanged(contactStatus, phoneStatus));
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<PermissionStatus> _getPhonePermission() async {
    PermissionStatus permission = await Permission.phone.status;
    if (permission != PermissionStatus.granted) {
      PermissionStatus permissionStatus = await Permission.phone.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus, String permission) {
    if (permissionStatus == PermissionStatus.denied) {
      var snackBar = SnackBar(content: Text("Access to $permission denied"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      var snackBar = SnackBar(
        content: Text(
          "$permission data not available on device. Allow Permissions from Settings.",
          style: StaticVisual.error,
        ),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
