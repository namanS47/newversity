import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/common/complete_profile_card.dart';
import 'package:newversity/flow/teacher/data/bloc/teacher_details/teacher_details_bloc.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';
import 'package:newversity/flow/teacher/profile/view/bootom_sheet_view/profile_completeness.dart';
import 'package:newversity/flow/teacher/profile/view/bootom_sheet_view/profile_set_session_rate.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/storage/app_constants.dart';

import '../../../../themes/colors.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../../utils/enums.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import '../model/education_response_model.dart';
import '../model/experience_response_model.dart';
import '../model/tags_response_model.dart';

class ProfileOverview extends StatefulWidget {
  final ProfileCompletionPercentageResponse percentageResponse;

  const ProfileOverview({Key? key, required this.percentageResponse})
      : super(key: key);

  @override
  State<ProfileOverview> createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  List<TagsResponseModel> allExpertise = [];
  List<TagsResponseModel> allMentorship = [];
  List<ExperienceResponseModel> lisOfExperienceModel = [];
  List<EducationResponseModel> listOfEducationModel = [];
  TeacherDetailsModel? teacherDetails;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(FetchTagEventByTeacherId());
    BlocProvider.of<ProfileBloc>(context).add(FetchTeachersExperienceEvent());
    BlocProvider.of<ProfileBloc>(context).add(FetchTeachersEducationEvents());
    BlocProvider.of<ProfileBloc>(context).add(FetchTeacherDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      listener: (context, state) {
        if (state is FetchedExpertiseState) {
          allExpertise = state.listOfTags;
        }
        if (state is FetchedMentorshipState) {
          allMentorship = state.listOfTags;
        }
        if (state is FetchedTeachersExperiencesState) {
          lisOfExperienceModel = state.listOfTeacherExperience;
        }
        if (state is FetchedTeacherEducationState) {
          listOfEducationModel = state.listOfTeacherEducation;
        }
        if (state is FetchedTeachersProfileState) {
          teacherDetails = state.teacherDetails;
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            widget.percentageResponse.completePercentage != 0
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                getAboutMe(),
                const SizedBox(
                  height: 10,
                ),
                getExpertise(),
                const SizedBox(
                  height: 10,
                ),
                getTalkingPoints(),
                const SizedBox(
                  height: 10,
                ),
                getLanguagePreferences(),
                const SizedBox(
                  height: 10,
                ),
                getHomeTown(),
                const SizedBox(
                  height: 10,
                ),
                getCompletenessCard(widget
                    .percentageResponse.completePercentage ??
                    0),
                getExperienceAndEducation(),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
                : CompleteProfileCard(
                profilePercentage:
                widget.percentageResponse.completePercentage ??
                    0),
            getPerSessionRateLayout(),
            const SizedBox(
              height: 100,
            ),
          ],
        );
        // return Expanded(
        //   child: CustomScrollView(
        //     slivers: <Widget>[
        //       SliverToBoxAdapter(
        //         child: ,
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }

  Widget getCompletenessCard(double profilePercentage) {
    return Visibility(
        visible: widget.percentageResponse.completePercentage != 100,
        child: CompleteProfileCard(profilePercentage: profilePercentage));
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
              teacherDetails != null
                  ? teacherDetails?.sessionPricing != null
                      ? getPerSessionRate()
                      : setYourFee()
                  : getProgressIndicator(40),
            ],
          ),
        ));
  }

  onAmountEditTap() async {
    if (widget.percentageResponse.completePercentage == 0) {
      await showModalBottomSheet<dynamic>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100.0),
              topRight: Radius.circular(100.0),
            ),
          ),
          isScrollControlled: true,
          builder: (_) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AppAnimatedBottomSheet(
                  bottomSheetWidget: ProfileCompletenessBottomSheet(
                reason: widget.percentageResponse.suggestion ?? "",
                isStudent: false,
              )),
            );
            // your stateful widget
          }).whenComplete(() {
        BlocProvider.of<ProfileBloc>(context).add(FetchTeacherDetailsEvent());
      });
    } else {
      await showModalBottomSheet<dynamic>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100.0),
              topRight: Radius.circular(100.0),
            ),
          ),
          isScrollControlled: true,
          builder: (_) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AppAnimatedBottomSheet(
                  bottomSheetWidget: BlocProvider<TeacherDetailsBloc>(
                      create: (context) => TeacherDetailsBloc(),
                      child: ProfileEditSessionRate(
                        longSessionFee:
                            teacherDetails?.sessionPricing?[SlotType.long.toString().split(".")[1]],
                        shortSessionFee: teacherDetails?.sessionPricing?[SlotType.short.toString().split(".")[1]],
                      ))),
            );
            // your stateful widget
          }).whenComplete(() {
        BlocProvider.of<ProfileBloc>(context).add(FetchTeacherDetailsEvent());
      });
    }
  }

  Widget setYourFee() {
    return GestureDetector(
        onTap: () => onAmountEditTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            AppImage(
              image: ImageAsset.edit,
              color: AppColors.blackMerlin,
            ),
            AppText("Set Your Fee"),
          ],
        ));
  }

  Widget getPerSessionRate() {
    return InkWell(
      onTap: () => onAmountEditTap(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          setYourFee(),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              // Expanded(
              //     child: getSessionContainer(
              //         teacherDetails?.sessionPricing?[SlotType.short.toString().split(".")[1]] ?? 0,
              //         15)),
              // const SizedBox(
              //   width: 10,
              // ),
              Expanded(
                  child: getSessionContainer(
                      teacherDetails?.sessionPricing?[SlotType.long.toString().split(".")[1]] ?? 0,
                      30)),
            ],
          ),
        ],
      ),
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
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
        child: Column(
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getHeader("Education"),
        const SizedBox(
          height: 5,
        ),
        listOfEducationModel.isNotEmpty ? getEducation() : noDataFound(40)
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getEducationalDuration(index),
                  getCGPA(index),
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

  Widget getCGPA(int index) {
    return AppText(
      "CGPA-${listOfEducationModel[index].grade ?? ""}",
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }

  Widget getStream(int index) {
    return Text(
      listOfEducationModel[index].degree ?? "",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getEducationalDuration(int index) {
    String duraionString = DateTimeUtils.getEmploymentDurationDateTime(
        listOfEducationModel[index].startDate ?? DateTime.now());
    duraionString += "-";
    if (listOfEducationModel[index].currentlyWorkingHere == true) {
      duraionString += "Present";
    } else {
      duraionString += DateTimeUtils.getEmploymentDurationDateTime(
          listOfEducationModel[index].endDate ?? DateTime.now());
    }
    return Text(
      duraionString,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getEducationalInstitute(int index) {
    return Text(
      listOfEducationModel[index].name ?? "",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getEducation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
        lisOfExperienceModel[index].location ?? "",
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
    durationString += "-";
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
      lisOfExperienceModel[index].title ?? "",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getInstitute(int index) {
    return Text(
      lisOfExperienceModel[index].companyName ?? "",
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getDuration(index),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getHeader("Experience"),
        const SizedBox(
          height: 5,
        ),
        lisOfExperienceModel.isNotEmpty ? getExperience() : noDataFound(40)
      ],
    );
  }

  Widget getLanguagePreferences() {
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
            teacherDetails != null
                ? teacherDetails!.language != null
                    ? teacherDetails!.language!.isNotEmpty
                        ? getLanguagePreferenceList()
                        : noDataFound(40)
                    : noDataFound(40)
                : getProgressIndicator(40),
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
        teacherDetails?.language?.length ?? 0,
        (curIndex) {
          return getTagView(teacherDetails?.language?[curIndex] ?? "");
        },
      ),
    );
  }

  Widget getTalkingPoints() {
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
          return getTagView(allMentorship[curIndex].tagName ?? "");
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
            getLocationTagView(teacherDetails != null
                ? teacherDetails?.location ?? ""
                : "Invalid Teacher Data"),
          ],
        ),
      ),
    );
  }

  Widget getExpertise() {
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
            getHeader("Experts in"),
            const SizedBox(
              height: 5,
            ),
            allExpertise.isNotEmpty ? getListOfExperties() : noDataFound(40)
          ],
        ),
      ),
    );
  }

  Widget getProgressIndicator(double height) {
    return SizedBox(
      height: height,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
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
        allExpertise.length,
        (curIndex) {
          return getExpertiseView(curIndex);
        },
      ),
    );
  }

  Widget getExpertiseView(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getTagView(allExpertise[index].tagName ?? ""),
        BlocBuilder<ProfileBloc, ProfileStates>(
          builder: (context, state) {
            if (state is UploadDocumentLoadingState &&
                state.tag == allExpertise[index]) {
              return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
            if (state is UploadDocumentSuccessState &&
                state.tag == allExpertise[index]) {
              allExpertise[index].teacherTagDetails?.tagStatus = "InProcess";
              return const Text(
                "Verifying",
                style: TextStyle(color: AppColors.lightRedColorShadow400),
              );
            }
            switch (allExpertise[index].teacherTagDetails?.tagStatus) {
              case "Verified":
                return const Text(
                  "Verified",
                  style: TextStyle(color: AppColors.colorGreen),
                );
              case "Unverified":
                return uploadDocumentWidget(allExpertise[index]);
              case "Failed":
                return uploadDocumentWidget(allExpertise[index]);
              case "InProcess":
                return const Text(
                  "Verifying",
                  style: TextStyle(color: AppColors.lightRedColorShadow400),
                );
              default:
                return uploadDocumentWidget(allExpertise[index]);
            }
          },
        ),
      ],
    );
  }

  Widget uploadDocumentWidget(TagsResponseModel tag) {
    XFile? file;
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ImagePickerOptionBottomSheet(
              onCameraClick: () async {
                final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    preferredCameraDevice: CameraDevice.front,
                    imageQuality: AppConstants.documentUploadQuality);
                if (image != null) {
                  file = image;
                  Navigator.pop(context);
                }
              },
              onGalleryClick: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: AppConstants.documentUploadQuality,
                );
                if (image != null) {
                  file = image;
                  Navigator.pop(context);
                }
              },
            );
          },
        ).whenComplete(() {
          if (file != null) {
            context
                .read<ProfileBloc>()
                .add(UploadDocumentEvent(file: file!, tag: tag));
          }
        });
      },
      child: Row(
        children: [
          SvgPicture.asset(ImageAsset.uploadProfilePic),
          const AppText(
            "Upload documents",
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
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
            getHeader("About me"),
            const SizedBox(
              height: 5,
            ),
            AppText(
              teacherDetails?.info ?? "",
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
