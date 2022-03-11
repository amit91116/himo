import 'package:flutter/material.dart';

class MyTab extends StatefulWidget {
  final String title;
  final Widget body;

  const MyTab({Key? key, required this.title, required this.body}) : super(key: key);

  @override
  _TabState createState() => _TabState();
}

class _TabState extends State<MyTab> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: widget.body,
    );
  }
}
