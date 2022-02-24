import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData iconData;
  final double? size;
  final Color? color;
  final Color? backgroundColor;

  const CustomIconButton({Key? key, required this.iconData, this.size, this.onPressed, this.color, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 2,
      shape: const CircleBorder(),
      fillColor: backgroundColor,
      padding: const EdgeInsets.all(8),
      child: Icon(
        iconData,
        size: size,
        color: color,
      ),
    );
  }
}
