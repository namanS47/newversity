import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newversity/flow/teacher/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:newversity/flow/teacher/profile/model/education_request_model.dart';

import '../../../common/common_utils.dart';
import '../../../common/common_widgets.dart';
import '../../../resources/images.dart';
import '../../../themes/colors.dart';
import '../../../themes/strings.dart';
import '../../../utils/date_time_utils.dart';

class AddEducation extends StatefulWidget {
  const AddEducation({Key? key}) : super(key: key);

  @override
  State<AddEducation> createState() => _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  final TextEditingController _schoolController = TextEditingController();

  final TextEditingController _degreeController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();

  final TextEditingController _endDateController = TextEditingController();

  final TextEditingController _gradeController = TextEditingController();

  bool isRebuildWidgetState(ProfileStates state) {
    return state is SavingTeacherEducationState ||
        state is SavedTeacherEducationState ||
        state is SavingFailureTeacherEducationState;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      listenWhen: (previous, current) => isRebuildWidgetState(current),
      listener: (context, state) {
        if (state is SavedTeacherEducationState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Education Details Added",
              ),
            ),
          );
          Navigator.pop(context);
          // Navigator.of(context).pushNamed(AppRoutes.teacherProfileDashBoard);
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          getEducationLayout(),
                          const SizedBox(
                            height: 20,
                          ),
                          getSchoolHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getYourSchool(),
                          const SizedBox(
                            height: 20,
                          ),
                          getDegreeNameHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getYourDegreeName(),
                          const SizedBox(
                            height: 20,
                          ),
                          getStartDateHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getStartDate(),
                          const SizedBox(
                            height: 20,
                          ),
                          getEndDateHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getEndDate(),
                          const SizedBox(
                            height: 20,
                          ),
                          getCurrentlyWorkingLayout(),
                          const SizedBox(
                            height: 20,
                          ),
                          getCgpaHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getGradeTextField(),
                          const SizedBox(
                            height: 120,
                          ),
                          getErrorText(),
                        ],
                      ),
                    )),
                  ],
                ),
                Column(
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppCta(
                        onTap: () => onAddingEducation(context),
                        text: AppStrings.addEducation,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getErrorText() {
    return Visibility(
      visible: showErrorText,
      child: const Text(
        "Please fill all the details",
        style: TextStyle(color: AppColors.redColorShadow400),
      ),
    );
  }

  bool showErrorText = false;

  onAddingEducation(BuildContext context) async {
    if (isFormValid()) {
      showErrorText = false;
      BlocProvider.of<ProfileBloc>(context).add(
        SaveTeacherEducationEvents(
          educationRequestModel: EducationRequestModel(
              teacherId: CommonUtils().getLoggedInUser(),
              name: _schoolController.text,
              degree: _degreeController.text),
        ),
      );
    } else {
      setState(() {
        showErrorText = true;
      });
    }
  }

  bool isFormValid() {
    return _schoolController.text.isNotEmpty &&
        _degreeController.text.isNotEmpty;
  }

  bool isCurrentlyWorkingHere = false;

  Widget getCurrentlyWorkingLayout() {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
              value: isCurrentlyWorkingHere,
              onChanged: (bool? val) {
                isCurrentlyWorkingHere = val!;
                setState(() {});
              }),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          AppStrings.currentlyWorkingHere,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget getStartDate() {
    return InkWell(
      onTap: () => selectStartDate(context),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.grey32, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 12, right: 12, top: 10, bottom: 10),
                        fillColor: AppColors.grey35..withOpacity(0.83),
                        border: InputBorder.none,
                        hintText: "Start Date"),
                  ),
                ),
                SvgPicture.asset(ImageAsset.dateImage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getEndDate() {
    return InkWell(
      onTap: () => selectEndDate(context),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.grey32, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 12, right: 12, top: 10, bottom: 10),
                        fillColor: AppColors.grey35..withOpacity(0.83),
                        border: InputBorder.none,
                        hintText: "End Date"),
                  ),
                ),
                SvgPicture.asset(ImageAsset.dateImage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime? selectedStartDate;

  DateTime? selectedEndDate;

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100, 1),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      helpText: "Date of Birthdate",
      confirmText: "Okay",
      cancelText: "Cancel",
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: AppColors.whiteColor,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onSurface: AppColors.blackMerlin,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _startDateController.text =
          DateTimeUtils.getBirthFormattedDateTime(picked);
      selectedStartDate = picked;
      setState(() {});
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100, 1),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      helpText: "Date of Birthdate",
      confirmText: "Okay",
      cancelText: "Cancel",
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: AppColors.whiteColor,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onSurface: AppColors.blackMerlin,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _endDateController.text = DateTimeUtils.getBirthFormattedDateTime(picked);
      selectedEndDate = picked;
      setState(() {});
    }
  }

  Widget getEducationLayout() {
    return Row(
      children: [
        InkWell(
          onTap: () => getBack(),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 8),
            child: SvgPicture.asset(ImageAsset.arrowBack),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        getEducation(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void getBack() {
    Navigator.pop(context);
  }

  Widget getYourSchool() {
    return AppTextFormField(
      hintText: "Title",
      controller: _schoolController,
      isDense: true,
    );
  }

  Widget getYourDegreeName() {
    return AppTextFormField(
      hintText: "Degree",
      controller: _degreeController,
      isDense: true,
    );
  }

  Widget getGradeTextField() {
    return AppTextFormField(
      hintText: "Grade in CGPA or Percentage",
      controller: _gradeController,
      isDense: true,
    );
  }

  Widget getSchoolHeader() {
    return const Text(
      AppStrings.school,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getEmploymentTypeHeader() {
    return const Text(
      AppStrings.employmentType,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getDegreeNameHeader() {
    return const Text(
      AppStrings.degree,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getCgpaHeader() {
    return const Text(
      AppStrings.grade,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getStartDateHeader() {
    return const Text(
      AppStrings.startDate,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getEndDateHeader() {
    return const Text(
      AppStrings.endDate,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getLocationHeader() {
    return const Text(
      AppStrings.locationType,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getEducation() {
    return const Text(
      AppStrings.education,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
