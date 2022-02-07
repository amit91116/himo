import 'package:flutter/cupertino.dart';

import '../global/tab.dart';

class CallLogs extends StatefulWidget {
  const CallLogs({Key? key}) : super(key: key);

  @override
  _CallLogsState createState() => _CallLogsState();
}

class _CallLogsState extends State<CallLogs> {
  @override
  Widget build(BuildContext context) {
    return MyTab(
      title: "Call Logs",
      body: Column(
        children: const [
          Text("This is Call Logs Screen with a long text to test this body of the tab... Is this working fine?")
        ],
      ),
    );
  }
}
