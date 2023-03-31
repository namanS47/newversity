import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/profile/view/bootom_sheet_view/profile_set_session_rate.dart';
import 'package:newversity/resources/images.dart';

import '../../../../themes/colors.dart';
import '../../../../utils/date_time_utils.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import '../model/education_response_model.dart';
import '../model/experience_response_model.dart';
import '../model/tags_response_model.dart';

class ProfileOverview extends StatefulWidget {
  ProfileOverview({Key? key}) : super(key: key);

  @override
  State<ProfileOverview> createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  List<TagsResponseModel> allExperties = [];
  List<TagsResponseModel> allMentorship = [];
  List<ExperienceResponseModel> lisOfExperienceModel = [];
  List<EducationResponseModel> listOfEducationModel = [];
  TeacherDetails? teacherDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(FetchTagEventByTeacherId());
    BlocProvider.of<ProfileBloc>(context).add(FetchTeachersExperienceEvent());
    BlocProvider.of<ProfileBloc>(context).add(FetchTeachersEducationEvents());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      listener: (context, state) {
        if (state is FetchedExpertiesState) {
          allExperties = state.listOfTags;
        }
        if (state is FetchedMentorsipState) {
          allMentorship = state.listOfTags;
        }
        if (state is FetchedTeachersExperiencesState) {
          lisOfExperienceModel = state.listOfTeacherExperience;
        }
        if (state is FetchedTeacherEducationState) {
          listOfEducationModel = state.listOfTeacherEducation;
        }
        if (state is FetchedTeachersProfile) {
          teacherDetails = state.teacherDetails;
          // TODO: implement listener
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    getAboutMe(),
                    const SizedBox(
                      height: 10,
                    ),
                    getExperties(),
                    const SizedBox(
                      height: 10,
                    ),
                    getTalkingPoints(),
                    const SizedBox(
                      height: 10,
                    ),
                    getLanguagePrefrences(),
                    const SizedBox(
                      height: 10,
                    ),
                    getHomeTown(),
                    const SizedBox(
                      height: 10,
                    ),
                    getExperienceAndEducation(),
                    const SizedBox(
                      height: 10,
                    ),
                    getPerSessionRateLayout(),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getPerSessionRateLayout() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getHeader("Your Fees"),
              const SizedBox(
                height: 10,
              ),
              getPerSessionRate(),
            ],
          ),
        ));
  }

  onAmountEditTap() {
    showModalBottomSheet<dynamic>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (_) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: AppAnimatedBottomSheet(
                bottomSheetWidget: BlocProvider<ProfileBloc>(
                    create: (context) => ProfileBloc(),
                    child: const ProfileEditSessionRate())),
          );
          // your stateful widget
        });
  }

  Widget getPerSessionRate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () => onAmountEditTap(),
            child: const AppImage(
              image: ImageAsset.edit,
              color: AppColors.blackMerlin,
            )),
        Row(
          children: [
            Expanded(child: getSessionContainer(150, 15)),
            const SizedBox(
              width: 10,
            ),
            Expanded(child: getSessionContainer(250, 30))
          ],
        ),
      ],
    );
  }

  Widget getSessionContainer(double rupees, int sessionMin) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.lightCyan,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              "₹ $rupees",
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: 5,
            ),
            AppText(
              "For $sessionMin min session",
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget getExperienceAndEducation() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
        child: Wrap(
          direction: Axis.vertical,
          children: [
            getExperienceLayout(),
            const SizedBox(
              height: 20,
            ),
            getEducationLayout()
          ],
        ),
      ),
    );
  }

  Widget getEducationLayout() {
    return Column(
      children: [
        getHeader("Education"),
        const SizedBox(
          height: 5,
        ),
        listOfEducationModel.isNotEmpty ? getEducation() : noDataFound(40),
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
              getEducationalInstitute(index),
              const SizedBox(
                height: 5,
              ),
              getStream(index),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  getEducationalDuration(index),
                  const Spacer(),
                  getCGPA(index),
                ],
              ),
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
    );
  }

  Widget getCGPA(int index) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        "CGPA-${listOfEducationModel[index].grade}",
        style: const TextStyle(
            color: AppColors.secColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget getStream(int index) {
    return Text(
      "${listOfEducationModel[index].degree}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getEducationalDuration(int index) {
    String duraionString = DateTimeUtils.getEmploymentDurationDateTime(
        listOfEducationModel[index].startDate!);
    duraionString += "-";
    if (listOfEducationModel[index].currentlyWorkingHere == true) {
      duraionString += "Present";
    } else {
      duraionString += DateTimeUtils.getEmploymentDurationDateTime(
          listOfEducationModel[index].endDate!);
    }
    return Text(
      duraionString,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getEducationalInstitute(int index) {
    return Text(
      "${listOfEducationModel[index].name}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getEducation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 30,
        runSpacing: 12,
        children: List.generate(
          listOfEducationModel.length,
          (curIndex) {
            return getEducationView(curIndex);
          },
        ),
      ),
    );
  }

  Widget getExperience() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 30,
        runSpacing: 12,
        children: List.generate(
          lisOfExperienceModel.length,
          (curIndex) {
            return getExperienceView(curIndex);
          },
        ),
      ),
    );
  }

  Widget getMode(int index) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        "${lisOfExperienceModel[index].location}",
        style: const TextStyle(
            color: AppColors.secColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget getDuration(int index) {
    String duraionString = DateTimeUtils.getEmploymentDurationDateTime(
        lisOfExperienceModel[index].startDate!);
    duraionString += "-";
    if (lisOfExperienceModel[index].currentlyWorkingHere == true) {
      duraionString += "Present";
    } else {
      duraionString += DateTimeUtils.getEmploymentDurationDateTime(
          lisOfExperienceModel[index].endDate!);
    }

    return Text(
      duraionString,
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
              getDesignation(index),
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
                  const Spacer(),
                  getMode(index),
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

  Widget getExperienceLayout() {
    return Column(
      children: [
        getHeader("Experience"),
        const SizedBox(
          height: 5,
        ),
        listOfEducationModel.isNotEmpty ? getExperience() : noDataFound(40),
      ],
    );
  }

  List<String> languagePreferences = ["Sanskrit", "English", "Hindi"];

  Widget getLanguagePrefrences() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeader("Language Preference"),
            const SizedBox(
              height: 5,
            ),
            languagePreferences.isNotEmpty
                ? getLanguagePreferenceList()
                : noDataFound(40),
          ],
        ),
      ),
    );
  }

  Widget getLanguagePreferenceList() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        languagePreferences.length,
        (curIndex) {
          return getTagView(languagePreferences[curIndex]);
        },
      ),
    );
  }

  Widget getTalkingPoints() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeader("Talk me about"),
            const SizedBox(
              height: 5,
            ),
            allMentorship.isNotEmpty
                ? getListOfTalkingPoints()
                : noDataFound(40),
          ],
        ),
      ),
    );
  }

  Widget getListOfTalkingPoints() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        allMentorship.length,
        (curIndex) {
          return getTagView(allMentorship[curIndex].tagName.toString());
        },
      ),
    );
  }

  Widget getHomeTown() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeader("HomeTown/City"),
            const SizedBox(
              height: 5,
            ),
            getLocationTagView("Mumbai"),
          ],
        ),
      ),
    );
  }

  Widget getExperties() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeader("Experts in"),
            const SizedBox(
              height: 5,
            ),
            allExperties.isNotEmpty ? getListOfExperties() : noDataFound(40),
          ],
        ),
      ),
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

  Widget getListOfExperties() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        allExperties.length,
        (curIndex) {
          return getExpertiesView(curIndex);
        },
      ),
    );
  }

  List<String> location = ["Patna", "Bangalore", "Mumbai"];

  Widget getExpertiesView(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getTagView(allExperties[index].tagName.toString()),
        Row(
          children: [
            SvgPicture.asset(ImageAsset.uploadProfilePic),
            const AppText(
              "Upload documents",
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ],
        )
      ],
    );
  }

  Widget getLocationTagView(String tagName) {
    return Container(
      height: 27,
      decoration: BoxDecoration(
        color: AppColors.grey50.withOpacity(0.30),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppImage(
              image: ImageAsset.location,
              color: AppColors.blackMerlin,
            ),
            const SizedBox(
              width: 5,
            ),
            AppText(
              tagName,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget getTagView(String tagName) {
    return Container(
      height: 27,
      decoration: BoxDecoration(
        color: AppColors.grey50.withOpacity(0.30),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              tagName,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget getAboutMe() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeader("About me"),
            const SizedBox(
              height: 5,
            ),
            const AppText(
              "odio In dui. porta consectetur elementum Sed quis commodo in faucibus lacus efficitur. Praesent non odio non placerat nonestibulum elit. luctus orci urna Morbi non, lacus, tincidunt non In tincunt sit ex Nhv.",
              fontSize: 12,
              fontWeight: FontWeight.w400,
            )
          ],
        ),
      ),
    );
  }

  Widget getHeader(String header) {
    return AppText(
      header,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }
}
