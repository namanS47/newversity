import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newversity/flow/teacher/profile/experience_and_education.dart';
import 'package:newversity/flow/teacher/profile/personal_info.dart';
import 'package:newversity/flow/teacher/profile/teaching_prefrences.dart';

class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({Key? key}) : super(key: key);

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {


  List<Widget> profileCardList = [
    const PersonalInformation(),
    const ExperienceAndEducation(),
    const TeachingPreferences(),
  ];




  @override
  Widget build(BuildContext context) {


    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Text(""),
          ),
        ],
      ),
    );
  }
}
