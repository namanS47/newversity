import 'package:flutter/material.dart';
import 'package:newversity/navigation/app_routes.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("Welcome to Teacher Home Page Route")),
          SizedBox(height: 20,),
          Center(child: InkWell(onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.availabilityRoute);
          },child: Text("Add availability")),)
        ],
      ),
    );
  }
}
