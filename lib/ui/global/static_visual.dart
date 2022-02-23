import 'package:flutter/material.dart';
import 'package:himo/ui/global/constants.dart';

class StaticVisual {
  static Widget smallHeight = SizedBox(height: 8, child: Container());
  static Widget mediumHeight = SizedBox(height: 16, child: Container());
  static Widget largeHeight = SizedBox(height: 32, child: Container());

  static Widget smallWidth = SizedBox(width: 8, child: Container());
  static Widget mediumWidth = SizedBox(width: 16, child: Container());
  static Widget largeWidth = SizedBox(width: 32, child: Container());

  static TextStyle error = const TextStyle(color: Colors.red);

  static double usableHeight(BuildContext context) => MediaQuery.of(context).size.height - Constants.navHeight;

  static double usableWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static Color incomingColor = const Color.fromARGB(255, 0, 255, 0);
  static Color outgoingColor = const Color.fromARGB(255, 0, 0, 255);
  static Color missedColor = const Color.fromARGB(255, 255, 0, 0);

  static Color bgIconColor(BuildContext context) => Theme.of(context).colorScheme.onBackground.withOpacity(0.08);
  static Color bgBoxColor = const Color.fromARGB(255, 252, 202, 201);

  static boxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      color: bgBoxColor,
    );
  }

  static boxDec(BuildContext context) {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      border: Border.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.08)),
      color: Theme.of(context).colorScheme.background,
    );
  }
}
