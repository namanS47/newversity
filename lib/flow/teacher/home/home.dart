import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/home/bloc/home_session_bloc/home_session_details_bloc.dart';
import 'package:newversity/flow/teacher/home/model/session_data.dart';
import 'package:newversity/flow/teacher/home/model/session_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';
import 'package:newversity/utils/date_time_utils.dart';
import 'package:newversity/utils/enums.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../profile/model/profile_dashboard_arguments.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSessionBooked = true;
  TeacherDetailsModel? teacherDetails;
  StudentDetail? studentDetails;
  List<SessionDetailsResponse>? listOfSessionDetailResponse = [];
  SessionDetailsResponse? nearestStartSession;
  ProfileCompletionPercentageResponse? profileCompletionPercentageResponse;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeSessionBloc>(context)
        .add(FetchProfilePercentageInfoEvent());
    BlocProvider.of<HomeSessionBloc>(context).add(FetchTeacherDetailEvent());
    BlocProvider.of<HomeSessionBloc>(context).add(
        FetchSessionDetailEvent(type: getSessionType(SessionType.upcoming)));
  }

  Future<void> assignNearestSessionDetail() async {
    if (listOfSessionDetailResponse != null &&
        listOfSessionDetailResponse?.isNotEmpty == true) {
      int minSecond = getLeftTimeInSeconds(
          listOfSessionDetailResponse?[0].startDate ?? DateTime.now());
      for (SessionDetailsResponse? sessionDetailsResponse
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
      },
      builder: (context, state) {
        return teacherDetails != null
            ? Column(
                children: [
                  teacherDetails != null
                      ? HomeAppBar(
                          teacherDetails: teacherDetails, appSizeHeight: 100)
                      : Container(),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5),
                          child: Column(
                            children: [
                              profileCompletionPercentageResponse != null
                                  ? getCompleteProfileContainer()
                                  : Container(),
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
                                  : Container()
                            ],
                          ),
                        )
                      ],
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
                "Next session with ${studentDetails?.name ?? "Mahesh"}",
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
                onDone: () {
                  isTimeUp = true;
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
                onDone: () {
                  isTimeUp = true;
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

  Widget getWatchVideoCTA() {
    return Container(
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
                  "Total Earnings"),
            )),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: getDetailsContainer(
                    AppColors.lightRedColorShadow400,
                    ImageAsset.bookings,
                    AppColors.totalBookingsColor,
                    "00",
                    "Total Bookings")),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
                child: getDetailsContainer(
                    AppColors.lightGreen,
                    ImageAsset.upcoming,
                    AppColors.upcomingScheduleColor,
                    "00",
                    "Upcoming Schedule")),
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
    return Column(
      children: [
        Visibility(
          visible:
              profileCompletionPercentageResponse?.completePercentage == 100.0,
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
                  getSessionDateAndTime(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
            visible: profileCompletionPercentageResponse?.completePercentage !=
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
                    padding:
                        const EdgeInsets.only(left: 28.0, top: 25, bottom: 25),
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
                    "Next session with"
                    "${nearestStartSession?.studentId ?? " "}",
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
    return Visibility(
      visible: profileCompletionPercentageResponse?.completePercentage != 100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primaryColor,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                  height: 5,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 100.0),
                  child: AppText(
                    AppStrings.addingDetailsInst,
                    fontSize: 12,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                getCompleteProfileCTA()
              ],
            ),
          ),
        ),
      ),
    );
  }

  onTapCompleteProfileCTA() {
    Navigator.of(context).pushNamed(AppRoutes.teacherProfileDashBoard,
        arguments:
            ProfileDashboardArguments(directedIndex: 1, showBackButton: true));
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
}

class HomeAppBar extends PreferredSize {
  final double appSizeHeight;
  final TeacherDetailsModel? teacherDetails;

  HomeAppBar(
      {Key? key, required this.appSizeHeight, required this.teacherDetails})
      : super(
            key: key,
            child: Container(),
            preferredSize: Size.fromHeight(appSizeHeight));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
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
            "Hi ${teacherDetails?.name ?? "Guest"}",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          const AppText("Good Morning!")
        ],
      ),
    ));
  }

  Widget getNotificationIcon() {
    return const AppImage(image: ImageAsset.notification);
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
          foregroundImage: teacherDetails?.profilePictureUrl != null
              ? NetworkImage(teacherDetails!.profilePictureUrl!)
              : null,
          child: teacherDetails?.profilePictureUrl == null
              ? const AppImage(
                  image: ImageAsset.blueAvatar,
                )
              : CommonWidgets.getCircularProgressIndicator(),
        ),
      ),
    );
  }
}
