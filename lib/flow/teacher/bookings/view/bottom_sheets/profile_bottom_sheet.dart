import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

class ProfileBottomSheet extends StatefulWidget {
  const ProfileBottomSheet({Key? key}) : super(key: key);

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {

  List<String> communicationLanguageList = ["English", "Hindi", "Sanskrit"];
  List<String> listOfTargetExam = ["Neet"];
  List<String> listOfAcademicInformation = ["+2 Passed"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Container(
            height: 2,
            width: 60,
            decoration: BoxDecoration(color: AppColors.grey50),
          )),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              children: [
                getProfileImage(ImageAsset.blueAvatar),
                const SizedBox(
                  height: 10,
                ),
                const AppText(
                  "Ikshit Anand",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(
                  height: 20,
                ),
                getLocationView(),
                const SizedBox(
                  height: 20,
                ),
                const AppText(
                  "Hello, my name is Mahesh, and I am a 12 grade student. I have always been curious about the world around me and enjoy learning new things. I also enjoy exploring different areas of knowledge",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          getAcademicInformation(),
          const SizedBox(
            height: 20,
          ),
          getTargetExamView(),
          const SizedBox(
            height: 20,
          ),
          getCommunicationLanguage(),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }



  Widget getCommunicationLanguage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Communication Language",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 15,
          runSpacing: 12,
          children: List.generate(
            communicationLanguageList.length,
            (curIndex) {
              return comView(curIndex);
            },
          ),
        )
      ],
    );
  }



  Widget getTargetExamView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Target Exam",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 15,
          runSpacing: 12,
          children: List.generate(
            listOfTargetExam.length,
            (curIndex) {
              return targetView(curIndex);
            },
          ),
        )
      ],
    );
  }

  Widget comView(int index) {
    return Container(
      width: 78,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
          child: AppText(
            communicationLanguageList[index],
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget targetView(int index) {
    return Container(
      width: 78,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
          child: AppText(
            listOfTargetExam[index],
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }



  Widget getAcademicInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Academic Information",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 15,
          runSpacing: 12,
          children: List.generate(
            listOfAcademicInformation.length,
            (curIndex) {
              return academicView(curIndex);
            },
          ),
        )
      ],
    );
  }

  Widget academicView(int index) {
    return Container(
      width: 78,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
          child: AppText(
            listOfAcademicInformation[index],
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget getLocationView() {
    return Container(
      width: 83,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AppImage(image: ImageAsset.location),
              SizedBox(
                width: 5,
              ),
              AppText(
                "Mumbai",
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getProfileImage(String img) {
    return SizedBox(
      height: 66,
      width: 66,
      child: CircleAvatar(
        radius: 200,
        child: AppImage(
          image: img,
        ),
      ),
    );
  }
}
