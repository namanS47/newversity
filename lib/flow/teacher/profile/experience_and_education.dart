import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/profile/profile_bloc/profile_bloc.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/themes/colors.dart';

import '../../../common/common_widgets.dart';
import '../../../themes/strings.dart';
import '../../student/seesion/data/experience_data.dart';

class ExpereinceAndEducation extends StatelessWidget {
  ExpereinceAndEducation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              getExperienceAndQualificationHeader(),
              const SizedBox(
                height: 20,
              ),
              getContainerHeaderLayout(
                  AppStrings.experience, context),
              const SizedBox(
                height: 10,
              ),
              getExperienceLayout(),
              const SizedBox(
                height: 20,
              ),
              getEducationContainerLayout(AppStrings.education, context),
              const SizedBox(
                height: 10,
              ),
              getEducationLayout(),
            ],
          ),
        ),
        Container(),
        const SizedBox(height: 100,),
        AppCta(
          text: "Proceed",
          isLoading: false,
          onTap: () => onTapContinueButton(context),
        )
      ],
    );
  }

  List<EducationData> educationData = EducationData.educationData;

  Widget getEducationLayout() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: educationData.length,
        itemBuilder: (context, index) => getEducationView(index),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 24),
      ),
    );
  }

  Widget getEducationView(int index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.lightCyan,
            child: Icon(
              Icons.add_business_outlined,
              color: AppColors.strongCyan,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getEducationalInstitute(index),
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
          const SizedBox(
            width: 10,
          ),
          getCGPA(index),
        ],
      ),
    );
  }

  List<ExperienceData> experienceData = ExperienceData.experienceData;

  Widget getExperienceLayout() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: experienceData.length,
        itemBuilder: (context, index) => getExperienceView(index),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 24),
      ),
    );
  }

  Widget getExperienceView(int index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.lightCyan,
            child: Icon(
              Icons.card_travel,
              color: AppColors.strongCyan,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getDesignation(index),
                const SizedBox(
                  height: 5,
                ),
                getInstitute(index),
                const SizedBox(
                  height: 5,
                ),
                getDuration(index),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          getMode(index),
        ],
      ),
    );
  }

  Widget getStream(int index) {
    return Text(
      "${educationData[index].stream}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getEducationalDuration(int index) {
    return Text(
      "${educationData[index].duration}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getEducationalInstitute(int index) {
    return Text(
      "${educationData[index].institution}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getMode(int index) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        "${experienceData[index].mode}",
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
        "${educationData[index].cgpa}",
        style: const TextStyle(
            color: AppColors.secColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget getDuration(int index) {
    return Text(
      "${experienceData[index].duration}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getDesignation(int index) {
    return Text(
      "${experienceData[index].designation}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getInstitute(int index) {
    return Text(
      "${experienceData[index].institution}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  onAddingEducation(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.addEducation);
  }

  onAddingExperience(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.addExperience);
  }

  Widget getContainerHeaderLayout(String headerName,context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.grey35.withOpacity(0.90)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getContainerHeader(headerName),
              InkWell(
                onTap: () => onAddingExperience(context),
                child: Icon(
                  Icons.add,
                  color: AppColors.blackMerlin.withOpacity(0.73),
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getEducationContainerLayout(String headerName,context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.grey35.withOpacity(0.90)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getContainerHeader(headerName),
              InkWell(
                onTap: () => onAddingEducation(context),
                child: Icon(
                  Icons.add,
                  color: AppColors.blackMerlin.withOpacity(0.73),
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getContainerHeader(String headerName) {
    return Text(
      headerName,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getExperienceAndQualificationHeader() {
    return const Text(
      AppStrings.experienceAndEducation,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  onTapContinueButton(BuildContext context) async {
    await context
        .read<ProfileBloc>()
        .changeIndex(context.read<ProfileBloc>().currentProfileStep);
  }
}
