import 'package:flutter/cupertino.dart';

import '../../../common/common_widgets.dart';
import '../../../themes/colors.dart';
import '../../../themes/strings.dart';

class SelectionDetails extends StatefulWidget {
  const SelectionDetails({Key? key}) : super(key: key);

  @override
  State<SelectionDetails> createState() => _SelectionDetailsState();
}

class _SelectionDetailsState extends State<SelectionDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getSelectionHeader(),
          const SizedBox(
            height: 20,
          ),
          selectExamNames(),
          const SizedBox(
            height: 20,
          ),
          getSelectedComptetiveExams(),
          const SizedBox(
            height: 20,
          ),
          const AppCta(
            text: "Proceed",
          )
        ],
      ),
    );
  }

  List<String> examsCracked = [
    "Personal Mentorship",
    "Exam prep strategy",
    "Career/Market/Industry insights/Future Trends",
    "College Planning",
    "Course/Stream Planning",
    "Interview prep",
    "Job preparation",
    "Professional life experience",
    "Others",
  ];

  Widget getSelectedComptetiveExams() {
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

  Widget getSelectionHeader() {
    return const Text(
      AppStrings.examsSelectionHeader,
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
