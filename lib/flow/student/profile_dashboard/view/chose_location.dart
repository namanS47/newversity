import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';

class StudentProfileLocation extends StatefulWidget {
  const StudentProfileLocation({Key? key}) : super(key: key);

  @override
  State<StudentProfileLocation> createState() => _StudentProfileLocationState();
}

class _StudentProfileLocationState extends State<StudentProfileLocation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Center(
          child: AppText("This is Location Choosing Scrren"),
        )
      ],
    );
  }
}
