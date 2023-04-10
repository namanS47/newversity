import 'package:flutter/material.dart';

import '../../../../common/common_widgets.dart';

class StudentCampusScreen extends StatefulWidget {
  const StudentCampusScreen({Key? key}) : super(key: key);

  @override
  State<StudentCampusScreen> createState() => _StudentCampusScreenState();
}

class _StudentCampusScreenState extends State<StudentCampusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Center(
            child: AppText("This is Student Campus Page"),
          )
        ],
      ),
    );
  }
}
