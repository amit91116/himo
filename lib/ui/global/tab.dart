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
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: widget.body,
    );
  }
}
