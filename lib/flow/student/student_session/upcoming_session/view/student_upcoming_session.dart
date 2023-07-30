import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/student_session/upcoming_session/bloc/student_upcoming_session_bloc.dart';
import 'package:newversity/flow/teacher/bookings/model/session_detail_arguments.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/room/model/room_argument.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../common/mentor_personal_detail_card.dart';
import '../../../../../resources/images.dart';
import '../../../../../themes/colors.dart';
import '../../../../../utils/enums.dart';
import '../../my_session/model/session_detail_response_model.dart';

class StudentUpcomingSessionScreen extends StatefulWidget {
  const StudentUpcomingSessionScreen({Key? key}) : super(key: key);

  @override
  State<StudentUpcomingSessionScreen> createState() =>
      _StudentUpcomingSessionScreenState();
}

class _StudentUpcomingSessionScreenState
    extends State<StudentUpcomingSessionScreen> {
  List<SessionDetailResponseModel> listOfUpcomingSessions = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentUpcomingSessionBloc>(context).add(
        FetchStudentUpcomingSessionEvent(
            sessionType: getSessionType(SessionType.upcoming)));
  }

  bool isRebuildWidgetState(StudentUpcomingSessionStates state) {
    return state is FetchingStudentUpcomingSessionState ||
        state is FetchingStudentUpcomingSessionFailureState ||
        state is FetchedStudentUpcomingSessionState ||
        state is UpcomingDataNotFoundState;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 0), () {
          BlocProvider.of<StudentUpcomingSessionBloc>(context).add(
              FetchStudentUpcomingSessionEvent(
                  sessionType: getSessionType(SessionType.upcoming)));
        });
      },
      child: ListView(
        children: [
          BlocConsumer<StudentUpcomingSessionBloc,
                  StudentUpcomingSessionStates>(
              buildWhen: (previous, current) => isRebuildWidgetState(current),
              listenWhen: (previous, current) => isRebuildWidgetState(current),
              listener: (context, state) {
                if (state is FetchedStudentUpcomingSessionState) {
                  listOfUpcomingSessions = state.listOfUpcomingSession;
                }
              },
              builder: (context, state) {
                if (state is FetchingStudentUpcomingSessionState) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 150),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.cyanBlue,
                      ),
                    ),
                  );
                } else if (state is UpcomingDataNotFoundState) {
                  return const SizedBox(
                    height: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: AppText(
                            "No Upcoming Session Found",
                          ),
                        )
                      ],
                    ),
                  );
                } else if (state
                    is FetchingStudentUpcomingSessionFailureState) {
                  return SizedBox(
                    height: 400,
                    child: Column(
                      children: [
                        Center(
                          child: AppText(state.msg),
                        )
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      getMentorsList(),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget getMentorsList() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        listOfUpcomingSessions.length,
        (curIndex) {
          return getMentorDetailsView(curIndex);
        },
      ),
    );
  }

  Widget getMentorsProfileImage(int index) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: 100,
      child: listOfUpcomingSessions[index].teacherDetail?.profilePictureUrl ==
                  null ||
              listOfUpcomingSessions[index]
                      .teacherDetail
                      ?.profilePictureUrl
                      ?.contains("https") ==
                  false
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: AppImage(
                  image: ImageAsset.blueAvatar,
                ),
              ),
            )
          : Image.network(
              listOfUpcomingSessions[index].teacherDetail?.profilePictureUrl ??
                  "",
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: AppImage(
                      image: ImageAsset.blueAvatar,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget getRateContainer(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey32,
        borderRadius: BorderRadius.circular(11.0),
      ),
      width: 32,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.star,
              size: 8,
              color: Colors.amber,
            ),
            AppText(
              "${listOfUpcomingSessions[index].studentRating ?? 3}",
              fontSize: 10,
            )
          ],
        ),
      ),
    );
  }

  onSessionTap(int index) {
    Navigator.of(context).pushNamed(AppRoutes.studentSessionDetailRoute,
        arguments: SessionDetailArguments(
            id: listOfUpcomingSessions[index].id.toString(),
            isPrevious: false,
            sessionDetails: listOfUpcomingSessions[index]));
  }

  Widget getMentorDetailsView(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.grey32),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          MentorPersonalDetailCard(
            mentorDetail: listOfUpcomingSessions[index].teacherDetail!,
            onCardTap: () => onSessionTap(index),
          ),
          GestureDetector(
            onTap: () => onSessionTap(index),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.mentorsAmountColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppText(
                                "₹ ${listOfUpcomingSessions[index].amount?.toInt()}",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              AppText(
                                listOfUpcomingSessions[index].sessionType ==
                                        "long"
                                    ? "/ ${getSessionTypeWithSlotType(SlotType.long)}"
                                    : "/ ${getSessionTypeWithSlotType(SlotType.short)}",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                          getScheduleLeftTime(index),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => getLeftTimeInSeconds(
                                    listOfUpcomingSessions[index].startDate ??
                                        DateTime.now()) <
                                1801
                            ? onJoinNowTap(index)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          height: 52,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: getLeftTimeInSeconds(
                                          listOfUpcomingSessions[index]
                                                  .startDate ??
                                              DateTime.now()) <
                                      1801
                                  ? AppColors.cyanBlue
                                  : AppColors.grey55),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                "JOIN NOW",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.whiteColor,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onJoinNowTap(int index) {
    Navigator.of(context).pushNamed(AppRoutes.roomPageRoute,
        arguments: RoomArguments(
            sessionDetails: listOfUpcomingSessions[index], forStudents: true));
  }

  int getLeftTimeInSeconds(DateTime dateTime) {
    return (dateTime.difference(DateTime.now()).inSeconds);
  }

  Widget getScheduleLeftTime(int index) {
    int timeLeftInSeconds = getLeftTimeInSeconds(
        listOfUpcomingSessions[index].startDate ?? DateTime.now());
    return SlideCountdown(
      duration: Duration(seconds: timeLeftInSeconds),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      slideDirection: SlideDirection.down,
      durationTitle: DurationTitle.id(),
      separator: ":",
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      separatorStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    );
  }
}
