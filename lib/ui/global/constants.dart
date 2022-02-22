
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Constants {
  static String get theme => "theme";

  static double get navHeight => 56;
  static final Widget whatsAppIcon = SvgPicture.asset(
    'assets/icons/whatsapp.svg',
    color: Colors.green,
    semanticsLabel: 'WhatsApp',
    height: 20,
    width: 20,
  );
}
