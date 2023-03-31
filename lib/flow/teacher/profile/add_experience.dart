import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newversity/flow/teacher/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:newversity/flow/teacher/profile/model/experience_request_model.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/date_time_utils.dart';
import 'package:newversity/utils/string_extensions.dart';

import '../../../common/common_utils.dart';
import '../../../common/common_widgets.dart';
import '../../../resources/images.dart';
import '../../../themes/strings.dart';

class AddExperience extends StatefulWidget {
  const AddExperience({Key? key}) : super(key: key);

  @override
  State<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  final TextEditingController _employmentController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _companyController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final List<String> locationTypeList = ['Home', 'Office'];
  String? locationTypeValue;
  final List<String> employmentTypeList = ['Salaried', 'Self Employed'];

  String? employmentTypeValue;
  bool showErrorText = false;
  bool isLoading = false;
  bool isCurrentlyWorkingHere = false;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  bool isRebuildWidgetState(ProfileStates state) {
    return state is SavingTeacherExperienceState ||
        state is SavedTeacherExperienceState ||
        state is SavingFailureTeacherExperienceState;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      listenWhen: (previous, current) => isRebuildWidgetState(current),
      listener: (context, state) {
        if (state is SavedTeacherExperienceState) {
          isLoading = false;
          Navigator.pop(context);
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
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
                      getExperienceLayout(),
                      const SizedBox(
                        height: 20,
                      ),
                      getTitleHeader(),
                      const SizedBox(
                        height: 10,
                      ),
                      getYourDesignation(),
                      const SizedBox(
                        height: 20,
                      ),
                      getEmploymentTypeHeader(),
                      const SizedBox(
                        height: 10,
                      ),
                      getEmploymentDropDownLayout(employmentTypeList),
                      const SizedBox(
                        height: 20,
                      ),
                      getCompanyNameHeader(),
                      const SizedBox(
                        height: 10,
                      ),
                      getYourCompanyName(),
                      const SizedBox(
                        height: 20,
                      ),
                      getLocationHeader(),
                      const SizedBox(
                        height: 10,
                      ),
                      getLocationDropDownLayout(locationTypeList),
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
                      Visibility(
                        visible: !isCurrentlyWorkingHere,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getEndDateHeader(),
                            const SizedBox(
                              height: 10,
                            ),
                            getEndDate(),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      getCurrentlyWorkingLayout(),
                      const SizedBox(
                        height: 20,
                      ),
                      getErrorText(),
                    ],
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppCta(
                    onTap: () => onAddingExperiences(context),
                    text: AppStrings.addExperience,
                    isLoading: isLoading
                  ),
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

  onAddingExperiences(BuildContext context) async {
    if (isFormValid()) {
      setState(() {
        showErrorText = false;
        isLoading = true;
      });
      BlocProvider.of<ProfileBloc>(context).add(
        SaveTeacherExperienceEvent(
          experienceRequestModel: ExperienceRequestModel(
            teacherId: CommonUtils().getLoggedInUser(),
            title: _titleController.text,
            employmentType: employmentTypeValue,
            companyName: _companyController.text,
            endDate: selectedEndDate,
            location: locationTypeValue,
            startDate: selectedStartDate,
            currentlyWorkingHere: isCurrentlyWorkingHere,
          ),
        ),
      );
    } else {
      setState(() {
        showErrorText = true;
      });
    }
  }

  bool isFormValid() {
    return _titleController.text.isNotEmpty &&
        employmentTypeValue.isValid &&
        _companyController.text.isNotEmpty &&
        locationTypeValue.isValid &&
        _startDateController.text.isNotEmpty &&
        (_endDateController.text.isValid || isCurrentlyWorkingHere);
  }

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

  Widget getLocationDropDownLayout(List<String> nameList) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.grey35,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppDropdownButton(
            hint: '-Select-',
            value: locationTypeValue,
            dropdownItems: nameList,
            onChanged: (value) => changeLocationType(value!),
          ),
        ),
      ),
    );
  }

  Widget getEmploymentDropDownLayout(List<String> nameList) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.grey35,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppDropdownButton(
            hint: '-Select-',
            value: employmentTypeValue,
            dropdownItems: nameList,
            onChanged: (value) => changeEmploymentType(value!),
          ),
        ),
      ),
    );
  }

  void changeEmploymentType(String value) {
    employmentTypeValue = value;
    setState(() {});
  }

  void changeLocationType(String value) {
    locationTypeValue = value;
    setState(() {});
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100, 1),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      // helpText: "Date of Birthdate",
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
          DateTimeUtils.getBirthFormattedDateTime(picked).toLowerCase();
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
      _endDateController.text = DateTimeUtils.getBirthFormattedDateTime(picked).toLowerCase();
      selectedEndDate = picked;
      setState(() {});
    }
  }

  Widget getExperienceLayout() {
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
        getExperienceHeader(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void getBack() {
    Navigator.pop(context);
  }

  Widget getYourDesignation() {
    return AppTextFormField(
      hintText: "Title",
      controller: _titleController,
      isDense: true,
    );
  }

  Widget getYourCompanyName() {
    return AppTextFormField(
      hintText: "Enter Here",
      controller: _companyController,
      isDense: true,
    );
  }

  Widget getTitleHeader() {
    return const Text(
      AppStrings.title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getEmploymentTypeHeader() {
    return const Text(
      AppStrings.employmentType,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getCompanyNameHeader() {
    return const Text(
      AppStrings.companyName,
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

  Widget getExperienceHeader() {
    return const Text(
      AppStrings.experience,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
