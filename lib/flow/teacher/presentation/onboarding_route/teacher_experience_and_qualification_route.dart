import 'package:flutter/material.dart';

class TeacherExperienceAndQualificationRoute extends StatefulWidget {
  const TeacherExperienceAndQualificationRoute({Key? key}) : super(key: key);

  @override
  State<TeacherExperienceAndQualificationRoute> createState() => _TeacherExperienceAndQualificationRouteState();
}

class _TeacherExperienceAndQualificationRouteState extends State<TeacherExperienceAndQualificationRoute> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Welcome to Teacher Experience and qualification route"),
      ),
    );
  }
}
