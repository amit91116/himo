import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../global/static_visual.dart';
import '../global/tab.dart';
import '../global/theme/app_theme.dart';
import '../global/theme/bloc/theme_bloc.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _CallLogsState createState() => _CallLogsState();
}

class _CallLogsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return MyTab(
      title: "Preferences",
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("App theme"),
                StaticVisual.largeWidth,
                Visibility(
                  child: TextButton(
                    child: const Icon(Icons.light_mode),
                    onPressed: () => {BlocProvider.of<ThemeBloc>(context).add(const ThemeChanged(AppTheme.light))},
                  ),
                  visible: Theme.of(context).brightness == Brightness.dark,
                  replacement: TextButton(
                    child: const Icon(Icons.dark_mode),
                    onPressed: () => {BlocProvider.of<ThemeBloc>(context).add(const ThemeChanged(AppTheme.dark))},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
