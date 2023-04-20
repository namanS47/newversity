import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/strings.dart';

import '../../../../../themes/colors.dart';
import '../../../../../utils/date_time_utils.dart';
import '../../../../teacher/profile/model/education_response_model.dart';
import '../../../../teacher/profile/model/experience_response_model.dart';
import '../bloc/student_session_bloc.dart';
import '../model/student_session_argument.dart';

class AboutSession extends StatefulWidget {
  final StudentSessionArgument studentSessionArgument;

  const AboutSession({Key? key, required this.studentSessionArgument})
      : super(key: key);

  @override
  State<AboutSession> createState() => _AboutSessionState();
}

class _AboutSessionState extends State<AboutSession> {
  TeacherDetails? teacherDetails;
  List<ExperienceResponseModel> lisOfExperienceModel = [];
  List<EducationResponseModel> listOfEducationModel = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentSessionBloc>(context).add(FetchTeacherDetailsEvent(
        teacherId: widget.studentSessionArgument.teacherId ?? ""));
    BlocProvider.of<StudentSessionBloc>(context).add(
        FetchTeacherExperienceEvent(
            teacherId: widget.studentSessionArgument.teacherId ?? ""));
    BlocProvider.of<StudentSessionBloc>(context).add(FetchTeacherEducationEvent(
        teacherId: widget.studentSessionArgument.teacherId ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSessionBloc, StudentSessionStates>(
      listener: (context, state) {
        if (state is FetchedTeacherDetailsState) {
          teacherDetails = state.teacherDetails;
        }
        if (state is FetchedTeacherExperienceState) {
          lisOfExperienceModel = state.listOfTeacherExperience;
        }
        if (state is FetchedTeacherEducationState) {
          listOfEducationModel = state.listOfTeacherEducation;
        }
      },
      builder: (context, state) {
        if (state is FetchedTeacherDetailsState ||
            state is FetchedTeacherEducationState ||
            state is FetchedTeacherExperienceState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getAboutHeader(),
              const SizedBox(
                height: 10,
              ),
              AppText(
                teacherDetails?.info ?? "",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 20,
              ),
              getLocationHeader(),
              const SizedBox(
                height: 10,
              ),
              getLocationLayout(),
              const SizedBox(
                height: 20,
              ),
              getLanguageHeader(),
              const SizedBox(
                height: 10,
              ),
              teacherDetails?.language != null
                  ? getLanguageLayout()
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              getExperienceHeader(),
              const SizedBox(
                height: 10,
              ),
              lisOfExperienceModel.isNotEmpty
                  ? getExperienceLayout()
                  : noDataFound(40),
              const SizedBox(
                height: 20,
              ),
              getEducationHeader(),
              const SizedBox(
                height: 10,
              ),
              listOfEducationModel.isNotEmpty
                  ? getEducationLayout()
                  : noDataFound(40),
              const SizedBox(
                height: 150,
              ),
            ],
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(
              height: 400,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.cyanBlue,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget noDataFound(double height) {
    return SizedBox(
      height: height,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: AppText("No data Found"),
        ),
      ),
    );
  }

  Widget getEducationLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        children: List.generate(
            listOfEducationModel.length, (index) => getEducationView(index)),
      ),
    );
  }

  Widget getExperienceLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 30,
        runSpacing: 12,
        children: List.generate(
            lisOfExperienceModel.length, (index) => getExperienceView(index)),
      ),
    );
  }

  Widget getExperienceView(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.lightCyan,
          child: AppImage(image: ImageAsset.experience),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getDesignation(index),
                  const Spacer(),
                  getMode(index),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              getInstitute(index),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  getDuration(index),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getEducationView(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.lightCyan,
          child: AppImage(image: ImageAsset.education),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getEducationalInstitute(index),
                  const Spacer(),
                  getCGPA(index),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              getStream(index),
              const SizedBox(
                height: 5,
              ),
              getEducationalDuration(index),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getStream(int index) {
    return Text(
      "${listOfEducationModel[index].degree}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getEducationalDuration(int index) {
    String durationString = DateTimeUtils.getEmploymentDurationDateTime(
        listOfEducationModel[index].startDate ?? DateTime.now());
    durationString += " - ";
    if (listOfEducationModel[index].currentlyWorkingHere == true) {
      durationString += "Present";
    } else {
      durationString += DateTimeUtils.getEmploymentDurationDateTime(
          listOfEducationModel[index].endDate ?? DateTime.now());
    }

    return Text(
      durationString,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getEducationalInstitute(int index) {
    return Text(
      "${listOfEducationModel[index].name}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getMode(int index) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        "${lisOfExperienceModel[index].employmentType}",
        style: const TextStyle(
            color: AppColors.secColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget getCGPA(int index) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        "${listOfEducationModel[index].grade}",
        style: const TextStyle(
            color: AppColors.secColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget getDuration(int index) {
    String durationString = DateTimeUtils.getEmploymentDurationDateTime(
        lisOfExperienceModel[index].startDate ?? DateTime.now());
    durationString += " - ";
    if (lisOfExperienceModel[index].currentlyWorkingHere == true) {
      durationString += "Present";
    } else {
      durationString += DateTimeUtils.getEmploymentDurationDateTime(
          lisOfExperienceModel[index].endDate ?? DateTime.now());
    }

    return Text(
      durationString,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getDesignation(int index) {
    return Text(
      "${lisOfExperienceModel[index].title}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getInstitute(int index) {
    return Text(
      "${lisOfExperienceModel[index].companyName}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getExperienceHeader() {
    return const Text(
      AppStrings.experience,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getEducationHeader() {
    return const Text(
      AppStrings.education,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getLanguageLayout() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: teacherDetails?.language?.length ?? 0,
        itemBuilder: (context, index) => getLanguageView(index),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 24),
      ),
    );
  }

  Widget getLanguageView(int index) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(25.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(teacherDetails?.language?[index] ?? "",
                color: AppColors.whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }

  Widget getLanguageHeader() {
    return const AppText(AppStrings.language,
        fontSize: 16, fontWeight: FontWeight.w600);
  }

  Widget getLocationLayout() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(30.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(ImageAsset.location),
            const SizedBox(
              width: 10,
            ),
            AppText(teacherDetails?.location ?? "",
                fontSize: 14,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }

  Widget getAboutHeader() {
    return const Text(
      AppStrings.about,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getLocationHeader() {
    return const Text(
      AppStrings.location,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
