import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/strings.dart';

import '../../../../../themes/colors.dart';
import '../../model/experience_data.dart';


class AboutSession extends StatelessWidget {
  AboutSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getAboutHeader(),
        const SizedBox(
          height: 10,
        ),
        const Text(
          AppStrings.aboutSession,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
        getLanguageLayout(),
        const SizedBox(
          height: 20,
        ),
        getExperienceHeader(),
        const SizedBox(
          height: 10,
        ),
        getExperienceLayout(),
        const SizedBox(
          height: 20,
        ),
        getEducationHeader(),
        const SizedBox(
          height: 10,
        ),
        getEducationLayout(),
        const SizedBox(
          height: 150,
        ),
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
            SizedBox(width: 24),
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

  final List<String> languages = const ["English", "Hindi"];

  Widget getLanguageLayout() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: languages.length,
        itemBuilder: (context, index) => getLanguageView(index),
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 24),
      ),
    );
  }

  Widget getLanguageView(int index) {
    return Container(
      height: 45,
      width: 100,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(25.0)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              languages[index],
              style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget getLanguageHeader() {
    return const Text(
      AppStrings.location,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getLocationLayout() {
    return Container(
      height: 45,
      width: 120,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(25.0)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(ImageAsset.location),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Mumbai",
              style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
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
