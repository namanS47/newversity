import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/flow/teacher/home/bloc/home_session_bloc/home_session_details_bloc.dart';
import 'package:newversity/flow/teacher/home/model/session_data.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';
import 'package:newversity/utils/date_time_utils.dart';
import 'package:newversity/utils/enums.dart';
import 'package:newversity/utils/event_broadcast.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../student/student_session/my_session/model/session_detail_response_model.dart';
import '../data/bloc/teacher_details/teacher_details_bloc.dart';
import '../profile/model/profile_dashboard_arguments.dart';
import '../profile/view/bootom_sheet_view/profile_set_session_rate.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSessionBooked = true;
  TeacherDetailsModel? teacherDetails;
  StudentDetail? studentDetails;
  List<SessionDetailResponseModel>? listOfSessionDetailResponse = [];
  SessionDetailResponseModel? nearestStartSession;
  ProfileCompletionPercentageResponse? profileCompletionPercentageResponse;
  int totalSessionCount = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeSessionBloc>(context)
        .add(FetchProfilePercentageInfoEvent());
    BlocProvider.of<HomeSessionBloc>(context).add(FetchTeacherDetailsEvent());
    BlocProvider.of<HomeSessionBloc>(context).add(
        FetchSessionDetailEvent(type: getSessionType(SessionType.upcoming)));
    BlocProvider.of<HomeSessionBloc>(context).add(FetchTeacherSessionCountEvent());
  }

  Future<void> assignNearestSessionDetail() async {
    if (listOfSessionDetailResponse != null &&
        listOfSessionDetailResponse?.isNotEmpty == true) {
      int minSecond = getLeftTimeInSeconds(
          listOfSessionDetailResponse?[0].startDate ?? DateTime.now());
      for (SessionDetailResponseModel? sessionDetailsResponse
          in listOfSessionDetailResponse!) {
        if (getLeftTimeInSeconds(
                sessionDetailsResponse?.startDate ?? DateTime.now()) <
            minSecond) {
          minSecond = getLeftTimeInSeconds(
              sessionDetailsResponse?.startDate ?? DateTime.now());
          nearestStartSession = sessionDetailsResponse;
        } else {
          nearestStartSession = listOfSessionDetailResponse?[0];
          continue;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeSessionBloc, HomeSessionStates>(
      listener: (context, state) {
        if (state is FetchedStudentDetailState) {
          studentDetails = state.studentDetails;
        }
        if (state is FetchedTeacherDetailState) {
          teacherDetails = state.teacherDetails;
        }
        if (state is FetchedSessionDetailState) {
          listOfSessionDetailResponse = state.sessionDetailResponse;
          assignNearestSessionDetail();
        }
        if (state is FetchedProfileCompletionInfoState) {
          profileCompletionPercentageResponse = state.percentageResponse;
        }
        if(state is FetchTeacherSessionCountSuccessState) {
          totalSessionCount = state.sessionCountResponseModel.totalSessionCount ?? 0;
        }
      },
      builder: (context, state) {
        return teacherDetails != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  teacherDetails != null
                      ? HomeAppBar(teacherDetails: teacherDetails)
                      : Container(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(const Duration(seconds: 0), () {
                          BlocProvider.of<HomeSessionBloc>(context)
                              .add(FetchProfilePercentageInfoEvent());
                          BlocProvider.of<HomeSessionBloc>(context).add(FetchTeacherDetailsEvent());
                          BlocProvider.of<HomeSessionBloc>(context).add(
                              FetchSessionDetailEvent(type: getSessionType(SessionType.upcoming)));
                          BlocProvider.of<HomeSessionBloc>(context).add(FetchTeacherSessionCountEvent());
                        });
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              if (profileCompletionPercentageResponse
                                      ?.completePercentage !=
                                  100)
                                getCompleteProfileContainer(),
                              profileCompletionPercentageResponse != null &&
                                      listOfSessionDetailResponse != null &&
                                      nearestStartSession != null
                                  ? getNextSessionDetailsContainer()
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              getDashBoardDetailContainers(),
                              const SizedBox(
                                height: 10,
                              ),
                              getHowItWorksContainer(),
                              const SizedBox(
                                height: 20,
                              ),
                              profileCompletionPercentageResponse != null &&
                                      profileCompletionPercentageResponse
                                              ?.completePercentage ==
                                          100.0
                                  ? listOfSessionDetailResponse != null
                                      ? getScheduleList()
                                      : const SizedBox(
                                          width: double.infinity,
                                          height: 200,
                                          child: ShimmerEffectView())
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(child: CircularProgressIndicator()),
                ],
              );
      },
    );
  }

  List<SessionData> listOfSessionData = SessionData.sessionDataList;

  Widget getScheduleList() {
    return Visibility(
      visible: listOfSessionDetailResponse!.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.grey35,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTodayScheduleHeader(),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 15,
              runSpacing: 12,
              children: List.generate(
                listOfSessionDetailResponse?.length ?? 0,
                (curIndex) {
                  return scheduleView(curIndex);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget scheduleView(int curIndex) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.whiteColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            AppText(
              listOfSessionDetailResponse?[curIndex].agenda ??
                  "This is agenda section",
              fontSize: 12,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 100.0),
              child: AppText(
                "Next session with ${studentDetails?.name ?? ""}",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            getScheduleDateAndTime(curIndex),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget getScheduleDateAndTime(int index) {
    String dateTime =
        "${DateTimeUtils.getBirthFormattedDateTime(listOfSessionDetailResponse?[index].startDate ?? DateTime.now())} ${DateTimeUtils.getTimeInAMOrPM(listOfSessionDetailResponse?[index].startDate ?? DateTime.now())}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          dateTime,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        getLeftTimeInSeconds(listOfSessionDetailResponse?[index].startDate ??
                    DateTime.now()) <
                1801
            ? getScheduleLeftTime(index)
            : Container()
      ],
    );
  }

  Widget getNearestSessionLeftTime() {
    int timeLeftInSeconds =
        getLeftTimeInSeconds(nearestStartSession?.startDate ?? DateTime.now());
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withOpacity(0.24),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const AppText("In "),
              SlideCountdown(
                duration: Duration(seconds: timeLeftInSeconds),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                slideDirection: SlideDirection.down,
                durationTitle: DurationTitle.id(),
                separator: ":",
                onChanged: (value) {
                  if (value.inSeconds < 1801) {
                    setState(() {});
                  }
                },
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                separatorStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          )

          // AppText(
          //   "$timeLeftInSeconds",
          //   fontSize: 12,
          //   fontWeight: FontWeight.w400,
          // ),
          ,
        ),
      ),
    );
  }

  bool isTimeUp = false;

  Widget getScheduleLeftTime(int index) {
    int timeLeftInSeconds = getLeftTimeInSeconds(
        listOfSessionDetailResponse?[index].startDate ?? DateTime.now());
    return Container(
      decoration: BoxDecoration(
        color: AppColors.strongCyan.withOpacity(0.24),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const AppText("In "),
              SlideCountdown(
                duration: Duration(seconds: timeLeftInSeconds),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                slideDirection: SlideDirection.down,
                durationTitle: DurationTitle.id(),
                separator: ":",
                onChanged: (value) {
                  if (value.inSeconds < 1801) {
                    setState(() {});
                  }
                },
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                separatorStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          )

          // AppText(
          //   "$timeLeftInSeconds",
          //   fontSize: 12,
          //   fontWeight: FontWeight.w400,
          // ),
          ,
        ),
      ),
    );
  }

  int getLeftTimeInSeconds(DateTime dateTime) {
    return (dateTime.difference(DateTime.now()).inSeconds);
  }

  Widget getTodayScheduleHeader() {
    return const Padding(
      padding: EdgeInsets.only(left: 10.0, top: 20),
      child: AppText(
        "Today's Schedule",
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget getHowItWorksContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.worksColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  const AppText(
                    AppStrings.howItWorks,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const AppText(
                    AppStrings.addingDetailsInst,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  getWatchVideoCTA()
                ],
              ),
            ),
          ),
          const AppImage(
            image: ImageAsset.character,
            height: 100,
          )
        ],
      ),
    );
  }

  Future<void> _launchAppWorkingVideo() async {
    final Uri url = Uri.parse("https://youtu.be/r6IYQTj5Qe8");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget getWatchVideoCTA() {
    return InkWell(
      onTap: () {
        _launchAppWorkingVideo();
      },
      child: Container(
        height: 25,
        width: 89,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: AppText(
              AppStrings.watchVideo,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  onTapOfTotalEarning() {
    Navigator.of(context).pushNamed(AppRoutes.totalEarning);
  }

  Widget getDashBoardDetailContainers() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onTapOfTotalEarning(),
                child: getDetailsContainer(
                  AppColors.lightCyanBlue,
                  ImageAsset.rupay,
                  AppColors.totalEarningColor,
                  "00",
                  "Total Earnings",
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: getDetailsContainer(
                AppColors.lightRedColorShadow400,
                ImageAsset.bookings,
                AppColors.totalBookingsColor,
                getSessionCount(totalSessionCount),
                "Total Bookings",
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  EventsBroadcast.get()
                      .send(ChangeHomePageIndexEvent(index: 1));
                },
                child: getDetailsContainer(
                  AppColors.lightGreen,
                  ImageAsset.upcoming,
                  AppColors.upcomingScheduleColor,
                  getSessionCount(listOfSessionDetailResponse?.length ?? 0),
                  "Upcoming Schedule",
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(child: getConditionalDetailContainer()),
          ],
        )
      ],
    );
  }

  Widget getConditionalDetailContainer() {
    return GestureDetector(
      onTap: () {
        if (profileCompletionPercentageResponse?.completePercentage == 100.0) {
          EventsBroadcast.get().send(ChangeHomePageIndexEvent(index: 2));
        } else {
          const snackBar = SnackBar(
            content: Text('Please complete your profile'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Column(
        children: [
          Visibility(
            visible: profileCompletionPercentageResponse?.completePercentage ==
                100.0,
            child: Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.nextAvailabilityColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, top: 25, bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.availCyan,
                      child: AppImage(
                        image: ImageAsset.availability,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    getSetAvailabilityCTA(),
                    // getSessionDateAndTime(),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
              visible:
                  profileCompletionPercentageResponse?.completePercentage !=
                      100.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.grey50,
                          blurRadius: 2.0,
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 28.0, top: 25, bottom: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.availCyan,
                            child: AppImage(
                              image: ImageAsset.availability,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          getSetAvailabilityCTA(),
                          getSessionDateAndTime(),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                      child: AppImage(
                    image: ImageAsset.lock,
                  ))
                ],
              ))
        ],
      ),
    );
  }

  Widget getSessionDateAndTime() {
    return Visibility(
      visible:
          profileCompletionPercentageResponse?.completePercentage == 100.0 &&
              nearestStartSession != null,
      child: Column(
        children: [
          AppText(
            "${DateTimeUtils.getBirthFormattedDateTime(nearestStartSession?.startDate ?? DateTime.now())} ${DateTimeUtils.getTimeInAMOrPM(nearestStartSession?.startDate ?? DateTime.now())}",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(
            height: 10,
          ),
          const AppText(
            "My next availability",
            fontSize: 12,
            fontWeight: FontWeight.w400,
          )
        ],
      ),
    );
  }

  Widget getSetAvailabilityCTA() {
    return Visibility(
      visible:
          profileCompletionPercentageResponse?.completePercentage == 100.0 &&
              listOfSessionDetailResponse != null,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 20),
        child: Container(
          height: 44,
          width: 132,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.availCyan, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: AppText(
                AppStrings.setAvailability,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDetailsContainer(
    Color iconBackgroundColor,
    String icon,
    Color containerBackgroundColor,
    String rupees,
    String containerTitle,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: containerBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 28.0, top: 25, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: iconBackgroundColor,
              child: AppImage(
                image: icon,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AppText(
              rupees,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: 10,
            ),
            AppText(
              containerTitle,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget getNextSessionDetailsContainer() {
    return Visibility(
      visible: listOfSessionDetailResponse!.isNotEmpty &&
          profileCompletionPercentageResponse?.completePercentage == 100.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.primaryColor,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                AppText(
                  nearestStartSession?.agenda ?? "This is Agenda Section",
                  fontSize: 12,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 100.0),
                  child: AppText(
                    "Next session with "
                    "${nearestStartSession?.studentDetail?.name ?? " "}",
                    fontSize: 14,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                getDateAndTimingOfSession(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getLeftTimeBeforeSession() {
    return Container(
      height: 28,
      width: 87,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          child: AppText(
            "In 30 M:19 S",
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget getDateAndTimingOfSession() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          getTimeText(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.whiteColor,
        ),
        getLeftTimeInSeconds(nearestStartSession?.startDate ?? DateTime.now()) <
                1801
            ? getNearestSessionLeftTime()
            : Container()
      ],
    );
  }

  String getTimeText() {
    String text = "";
    text =
        "${DateTimeUtils.getBirthFormattedDateTime(nearestStartSession?.startDate ?? DateTime.now())} ${DateTimeUtils.getTimeInAMOrPM(nearestStartSession?.startDate ?? DateTime.now())} - ${DateTimeUtils.getTimeInAMOrPM(nearestStartSession?.endDate ?? DateTime.now())}";
    return text;
  }

  Widget getCompleteProfileContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            const AppText(
              AppStrings.emptyProfile,
              fontSize: 14,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 100.0),
              child: AppText(
                profileCompletionPercentageResponse?.suggestion ?? "",
                fontSize: 12,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            getCompleteProfileCTA()
          ],
        ),
      ),
    );
  }

  onTapCompleteProfileCTA() async {
    final completionStageStatus =
        profileCompletionPercentageResponse?.profileCompletionStageStatus;
    int directedIndex = -1;
    bool setPricing = false;
    bool verifyTags = false;

    if (completionStageStatus != null) {
      if (completionStageStatus.containsKey(ProfileCompletionStage.Profile.toString().split(".")[1]) &&
          !completionStageStatus[
              ProfileCompletionStage.Profile.toString().split(".")[1]]!) {
        directedIndex = 1;
      } else if (completionStageStatus.containsKey(ProfileCompletionStage.ProfilePicture.toString().split(".")[1]) &&
          !completionStageStatus[
          ProfileCompletionStage.ProfilePicture.toString().split(".")[1]]!) {
        directedIndex = 1;
      } else if (completionStageStatus.containsKey(ProfileCompletionStage.Education.toString().split(".")[1]) &&
          !completionStageStatus[
              ProfileCompletionStage.Education.toString().split(".")[1]]!) {
        directedIndex = 2;
      } else if (completionStageStatus.containsKey(ProfileCompletionStage.Experience.toString().split(".")[1]) &&
          !completionStageStatus[
              ProfileCompletionStage.Experience.toString().split(".")[1]]!) {
        directedIndex = 2;
      } else if (completionStageStatus.containsKey(ProfileCompletionStage.Pricing.toString().split(".")[1]) && !completionStageStatus[ProfileCompletionStage.Pricing.toString().split(".")[1]]!) {
        setPricing = true;
      } else if (completionStageStatus.containsKey(
              ProfileCompletionStage.SelectTags.toString().split(".")[1]) &&
          !completionStageStatus[
              ProfileCompletionStage.SelectTags.toString().split(".")[1]]!) {
        directedIndex = 3;
      } else if (completionStageStatus
              .containsKey(ProfileCompletionStage.VerifiedTags.toString().split(".")[1]) &&
          !completionStageStatus[ProfileCompletionStage.VerifiedTags.toString().split(".")[1]]!) {
        verifyTags = true;
      }
    }

    if (directedIndex != -1) {
      await Navigator.of(context).pushNamed(AppRoutes.teacherProfileDashBoard,
          arguments: ProfileDashboardArguments(
              directedIndex: directedIndex, showBackButton: true));

    } else {
      if (verifyTags) {
        await Navigator.of(context).pushNamed(AppRoutes.profileScreen);
      } else if (setPricing) {
        await setFees();
      }
    }
    if(context.mounted){
      BlocProvider.of<HomeSessionBloc>(context)
          .add(FetchProfilePercentageInfoEvent());
    }
  }

  Future<void> setFees() async {
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
                      longSessionFee: teacherDetails?.sessionPricing?[
                          SlotType.long.toString().split(".")[1]],
                      shortSessionFee: teacherDetails?.sessionPricing?[
                          SlotType.short.toString().split(".")[1]],
                    ))),
          );
          // your stateful widget
        });
  }

  Widget getCompleteProfileCTA() {
    return GestureDetector(
      onTap: () => onTapCompleteProfileCTA(),
      child: Container(
        height: 26,
        width: 117,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            child: AppText(
              AppStrings.completeProfile,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String getSessionCount(int count) {
    if(count < 10) {
      return "0$count";
    } else {
      return count.toString();
    }
  }
}

class HomeAppBar extends StatefulWidget {
  final TeacherDetailsModel? teacherDetails;

  const HomeAppBar({Key? key, required this.teacherDetails}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
          height: 70,
          child: Row(
            children: [
              getProfileImage(context),
              const SizedBox(
                width: 10,
              ),
              getProfileName(),
              getNotificationIcon()
            ],
          )),
    ));
  }

  Widget getProfileName() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            "Hi ${widget.teacherDetails?.name ?? "Guest"}",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          const AppText("Good Morning!")
        ],
      ),
    ));
  }

  Widget getNotificationIcon() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.notificationRoute);
      },
      child: CommonWidgets.notificationWidget(),
    );
  }

  navigateToProfileScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.profileScreen);
  }

  Widget getProfileImage(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToProfileScreen(context),
      child: SizedBox(
        height: 44,
        width: 44,
        child: CircleAvatar(
          radius: 30.0,
          foregroundImage: widget.teacherDetails?.profilePictureUrl != null
              ? NetworkImage(widget.teacherDetails?.profilePictureUrl ?? "")
              : null,
          child: widget.teacherDetails?.profilePictureUrl == null
              ? const AppImage(
                  image: ImageAsset.blueAvatar,
                )
              : CommonWidgets.getCircularProgressIndicator(),
        ),
      ),
    );
  }
}
