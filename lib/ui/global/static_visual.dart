import 'package:flutter/material.dart';
import 'package:himo/ui/global/constants.dart';
import 'package:himo/ui/global/widgets/box_container.dart';

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
  static Color incomingColor = Colors.green;
  static Color outgoingColor = const Color.fromARGB(255, 0, 0, 255);
  static Color missedColor = Colors.red;

  static Color bgIconColor(BuildContext context) => Theme.of(context).colorScheme.onBackground.withOpacity(0.08);
  static Color bgBoxColor = const Color.fromARGB(255, 252, 202, 201);

  static boxDec(BuildContext context) {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      border: Border.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.08)),
      color: Colors.transparent,
    );
  }

  static BoxDecoration boxDecoration(context) => BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        /*gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
            ],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 0.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp),*/
        borderRadius: BorderRadius.circular(8),
      );

  static BoxDecoration boxDecorationWithShadow(context) => BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        /*gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
            ],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 0.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp),*/
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.background.withAlpha(120),
            offset: const Offset(0.0, 5.0),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ), //BoxShadow
          BoxShadow(
            color: Theme.of(context).colorScheme.surface.withAlpha(120),
            offset: const Offset(5.0, 0.0),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ), //BoxShadow
        ],
      );

  static BoxContainer boxContainer(List<Widget> child) => BoxContainer(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: child,
      ));
}
