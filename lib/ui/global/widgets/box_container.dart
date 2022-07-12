import 'package:flutter/material.dart';
import 'package:himo/ui/global/static_visual.dart';

class BoxContainer extends StatelessWidget {
  final Widget child;

  const BoxContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: StaticVisual.boxDecoration(context),
      child: child,
    );
  }
}
