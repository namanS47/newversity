import 'package:flutter/material.dart';

import '../../campus/ui/campus_route.dart';
import '../../webinar/ui/webinar_route.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabs Demo'),
        ),
        body: const TabBarView(
          children: [
            CampusTab(),
            WebinarTab(),
            Icon(Icons.directions_bike),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              text: "Campus",
            ),
            Tab(
              text: "Live Classes",
            ),
            Tab(
              text: "Sessions",
            ),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Colors.green,
        ),
      ),
    );
  }
}
