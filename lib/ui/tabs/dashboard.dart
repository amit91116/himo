import 'package:flutter/cupertino.dart';

import '../global/tab.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {



  @override
  Widget build(BuildContext context) {
    return MyTab(
      title: "Dashboard",
      body: Column(
        children: const [Text("This is Dashboard Screen")],
      ),
    );
  }
}
