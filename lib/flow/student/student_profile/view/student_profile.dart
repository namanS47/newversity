import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/student/student_profile/bloc/student_profile_bloc.dart';
import 'package:newversity/flow/student/student_profile/view/student_profile_drawer.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';
import 'package:newversity/themes/strings.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../common/common_widgets.dart';
import '../../../../navigation/app_routes.dart';
import '../../../../resources/images.dart';
import '../../../../themes/colors.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  StudentDetail? studentDetail;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ProfileCompletionPercentageResponse? profileCompletionPercentageResponse;

  onDrawerTap() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openEndDrawer();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<StudentProfileBloc>(context).add(FetchStudentEvent());
    BlocProvider.of<StudentProfileBloc>(context)
        .add(FetchProfileCompletenessInfoEvent());
  }

  Widget getProfileImage() {
    return Stack(
      children: [
        Container(
          height: 73,
          width: 73,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: SizedBox(
              height: 66,
              width: 66,
              child: CircleAvatar(
                radius: 30.0,
                foregroundImage: studentDetail?.profilePictureUrl != null
                    ? NetworkImage(studentDetail?.profilePictureUrl ?? "")
                    : null,
                child: studentDetail?.profilePictureUrl == null
                    ? const AppImage(
                        image: ImageAsset.blueAvatar,
                      )
                    : CommonWidgets.getCircularProgressIndicator(),
              ),
            ),
          ),
        ),
        Positioned(
            right: -2,
            bottom: 5,
            child:
                profileCompletionPercentageResponse?.completePercentage == 100
                    ? const AppImage(
                        image: ImageAsset.check,
                      )
                    : Container())
      ],
    );
  }

  Widget getDetailsWithEditLayout() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  studentDetail?.name ?? "",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                Container()
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            AppText(
              "Mob: ${studentDetail?.mobileNumber ?? ""}",
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: AppColors.blackMerlin,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: SizedBox(
          width: 240,
          child: BlocProvider<StudentProfileBloc>(
            create: (context) => StudentProfileBloc(),
            child: const StudentProfileDrawerScreen(),
          )),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 133,
                decoration:
                    const BoxDecoration(color: AppColors.perSessionRate),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => {Navigator.pop(context)},
                              child:
                                  const AppImage(image: ImageAsset.arrowBack)),
                          const SizedBox(
                            width: 20,
                          ),
                          const AppText(
                            "Profile",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => onDrawerTap(),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: AppImage(image: ImageAsset.drawer),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            bottom: 10,
            top: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocConsumer<StudentProfileBloc, StudentProfileStates>(
                listener: (context, state) {
                  if (state is FetchedStudentState) {
                    studentDetail = state.studentDetail;
                  }
                  if (state is FetchedProfileCompletenessInfoState) {
                    profileCompletionPercentageResponse =
                        state.profileCompletionPercentageResponse;
                  }
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 110,
                      ),
                      Row(
                        children: [
                          getProfileImage(),
                          const SizedBox(
                            width: 17,
                          ),
                          getDetailsWithEditLayout(),
                        ],
                      ),
                      Expanded(
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                              child: studentDetail != null &&
                                      profileCompletionPercentageResponse !=
                                          null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        getPercentageCompleteLayout(),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        getAboutMe(),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        getExpertise(),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        getLanguagePreferences(),
                                        getEmail(),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        getHomeTown(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        getConditionalProfileCompleteness(),
                                        const SizedBox(
                                          height: 100,
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Column(
                                        children: const [
                                          Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.cyanBlue,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  onEditTap() async {
    await Navigator.of(context).pushNamed(AppRoutes.editProfile);
    BlocProvider.of<StudentProfileBloc>(context).add(FetchStudentEvent());
    BlocProvider.of<StudentProfileBloc>(context)
        .add(FetchProfileCompletenessInfoEvent());
  }

  Widget getEditLayout() {
    return GestureDetector(
      onTap: () => onEditTap(),
      child: Row(
        children: const [
          AppText(
            "Edit",
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
          SizedBox(
            width: 5,
          ),
          AppImage(image: ImageAsset.edit),
        ],
      ),
    );
  }

  double percentageOfCompletion = 0.95;

  Widget getPercentageCompleteLayout() {
    return Visibility(
      visible:
          (profileCompletionPercentageResponse?.completePercentage ?? 0) > 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppText(
                    "Profile completeness",
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AppText(
                    "${profileCompletionPercentageResponse?.completePercentage ?? 0 * 100} %",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              getPercentageIndicator(253),
              const SizedBox(
                height: 10,
              ),
              AppText(
                profileCompletionPercentageResponse?.suggestion ?? "",
                color: AppColors.appYellow,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              )
            ],
          ),
          getEditLayout()
        ],
      ),
    );
  }

  Widget getPercentageIndicator(double width) {
    return LinearPercentIndicator(
      width: width,
      lineHeight: 8.0,
      animation: true,
      barRadius: const Radius.circular(10),
      animationDuration: 2000,
      percent: ((profileCompletionPercentageResponse?.completePercentage ?? 0) /
          100),
      progressColor: AppColors.primaryColor,
    );
  }

  Widget getAcademicInformation() {
    return Visibility(
      visible:
          (profileCompletionPercentageResponse?.completePercentage ?? 0) > 90,
      child: Container(
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
              getHeader("Academic Information"),
              const SizedBox(
                height: 8,
              ),
              AppText(
                studentDetail?.studentId ?? AppStrings.loremText,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getLocationTagAndEmailView(String tagName, String icon) {
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
            AppImage(
              image: icon,
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
              height: 8,
            ),
            getLocationTagAndEmailView(studentDetail != null
                ? studentDetail?.location ?? "Mumbai"
                : "Invalid Teacher Data", ImageAsset.location),
          ],
        ),
      ),
    );
  }

  Widget getEmail() {
    if(studentDetail?.email?.isNotEmpty == true) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 14),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getHeader("Email"),
              const SizedBox(
                height: 8,
              ),
              getLocationTagAndEmailView(studentDetail!.email!, ImageAsset.mail),
            ],
          ),
        ),
      );
    }
    return Container();
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
            getHeader("Target exam"),
            const SizedBox(
              height: 5,
            ),
            studentDetail != null
                ? studentDetail!.tags != null
                    ? studentDetail!.tags!.isNotEmpty
                        ? getTargetExamViewList()
                        : noDataFound(40)
                    : noDataFound(40)
                : getProgressIndicator(40),
          ],
        ),
      ),
    );
  }

  Widget getLanguagePreferences() {
    return Visibility(
      visible:
          (profileCompletionPercentageResponse?.completePercentage ?? 0) > 90,
      child: Container(
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
              getHeader("Communication Language"),
              const SizedBox(
                height: 8,
              ),
              studentDetail != null
                  ? studentDetail!.language != null
                      ? studentDetail!.language!.isNotEmpty
                          ? getLanguagePreferenceList()
                          : noDataFound(40)
                      : noDataFound(40)
                  : getProgressIndicator(40),
            ],
          ),
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

  Widget getTargetExamViewList() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        studentDetail?.tags?.length ?? 0,
        (curIndex) {
          return getTagView(studentDetail?.tags?[curIndex] ?? "");
        },
      ),
    );
  }

  Widget getLanguagePreferenceList() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        studentDetail?.language?.length ?? 0,
        (curIndex) {
          return getTagView(studentDetail?.language?[curIndex] ?? "");
        },
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

  Widget getConditionalProfileCompleteness() {
    return Visibility(
      visible:
          (profileCompletionPercentageResponse?.completePercentage ?? 0) <= 90,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppText(
                    "Profile Completeness",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AppText(
                    "${profileCompletionPercentageResponse?.completePercentage ?? 0} %",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              getPercentageIndicator(MediaQuery.of(context).size.width - 100),
              const SizedBox(
                height: 12,
              ),
              const Center(
                child: AppImage(
                  image: ImageAsset.icCompletenessWelcome,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  child: AppText(
                    profileCompletionPercentageResponse?.suggestion ??
                        "Please complete your profile first to interact with mentor",
                    textAlign: TextAlign.center,
                    color: AppColors.appYellow,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              AppCta(
                onTap: () => onCompleteProfileTap(),
                text: "Complete Profile",
              )
            ],
          ),
        ),
      ),
    );
  }

  onCompleteProfileTap() async {
    await Navigator.of(context).pushNamed(AppRoutes.editProfile);
    BlocProvider.of<StudentProfileBloc>(context).add(FetchStudentEvent());
    BlocProvider.of<StudentProfileBloc>(context)
        .add(FetchProfileCompletenessInfoEvent());
  }

  Widget getAboutMe() {
    return Visibility(
      visible:
          (profileCompletionPercentageResponse?.completePercentage ?? 0) > 90,
      child: Container(
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
                height: 8,
              ),
              AppText(
                studentDetail?.info ?? AppStrings.loremText,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              )
            ],
          ),
        ),
      ),
    );
  }
}
