import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/profile/profile_bloc/profile_bloc.dart';
import 'package:newversity/themes/colors.dart';

import '../../../themes/strings.dart';

class ExamsCracked extends StatefulWidget {
  const ExamsCracked({Key? key}) : super(key: key);

  @override
  State<ExamsCracked> createState() => _ExamsCrackedState();
}

class _ExamsCrackedState extends State<ExamsCracked> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getExamCrackedHeader(),
          const SizedBox(
            height: 20,
          ),
          selectExamNames(),
          const SizedBox(
            height: 20,
          ),
          getExamsLayout(),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () => onSubmitTap(context) ,
            child: const AppCta(
              text: "Proceed",
            ),
          )
        ],
      ),
    );
  }

  onSubmitTap(BuildContext context) async{
    await context.read<ProfileBloc>().changeIndex(
      context.read<ProfileBloc>().currentProfileStep,
    );
  }

  List<String> examsCracked = [
    "SSC Board Exams",
    "CBSE Board Exams",
    "NEET",
    "JEE Main",
    "JEE Advance",
    "HSC Board Exams",
    "Others"
  ];

  Widget getExamsLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 15,
        runSpacing: 12,
        children: List.generate(
          examsCracked.length,
          (curIndex) {
            return examsView(curIndex);
          },
        ),
      ),
    );
  }

  int selectedExams = -1;
  onSelectedSession(int index) {
    selectedExams = index;
    setState(() {});
  }

  Widget examsView(int curIndex) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onSelectedSession(curIndex),
          child: Container(
            height: 55,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: selectedExams == curIndex
                    ? AppColors.lightCyan
                    : AppColors.grey35,
                border: Border.all(width: 0.3, color: AppColors.grey32)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                examsCracked[curIndex],
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            )),
          ),
        ),
      ],
    );
  }

  Widget getExamCrackedHeader() {
    return const Text(
      AppStrings.examsCracked,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget selectExamNames() {
    return const Text(
      AppStrings.selectExamsInfo,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.blackMerlin),
    );
  }
}
