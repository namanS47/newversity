import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/mentor_personal_detail_card.dart';
import 'package:newversity/flow/student/student_session/previous_session/bloc/student_previous_session_bloc.dart';
import 'package:newversity/flow/student/student_session/previous_session/model/previous_session_details_model.dart';
import 'package:newversity/utils/date_time_utils.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../navigation/app_routes.dart';
import '../../../../../resources/images.dart';
import '../../../../../themes/colors.dart';
import '../../../../../utils/enums.dart';
import '../../../../teacher/bookings/model/session_detail_arguments.dart';
import '../../my_session/model/session_detail_response_model.dart';

class StudentPreviousSessionScreen extends StatefulWidget {
  const StudentPreviousSessionScreen({Key? key}) : super(key: key);

  @override
  State<StudentPreviousSessionScreen> createState() =>
      _StudentPreviousSessionScreenState();
}

class _StudentPreviousSessionScreenState
    extends State<StudentPreviousSessionScreen> {
  List<PreviousSessionDetailsModel> listOfMentorsDetails =
      PreviousSessionDetailsModel.listOfMentorsDetails;

  List<SessionDetailResponseModel> listOfPreviousSession = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentPreviousSessionBloc>(context).add(
        FetchStudentPreviousSessionEvent(
            sessionType: getSessionType(SessionType.previous)));
  }

  bool isRebuildWidgetState(StudentPreviousSessionState state) {
    return state is FetchingStudentPreviousSessionState ||
        state is FetchingStudentPreviousSessionFailureState ||
        state is FetchedStudentPreviousSessionState ||
        state is PreviousDataNotFoundState;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 0), () {
          BlocProvider.of<StudentPreviousSessionBloc>(context).add(
              FetchStudentPreviousSessionEvent(
                  sessionType: getSessionType(SessionType.previous)));
        });
      },
      child: ListView(
        children: [
          BlocConsumer<StudentPreviousSessionBloc, StudentPreviousSessionState>(
            buildWhen: (previous, current) => isRebuildWidgetState(current),
            listenWhen: (previous, current) => isRebuildWidgetState(current),
            listener: (context, state) {
              if (state is FetchedStudentPreviousSessionState) {
                listOfPreviousSession = state.listOfPreviousSession;
              }
            },
            builder: (context, state) {
              if (state is FetchingStudentPreviousSessionState) {
                return const Padding(
                  padding: EdgeInsets.only(top: 150),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.cyanBlue,
                    ),
                  ),
                );
              } else if (state is PreviousDataNotFoundState) {
                return SizedBox(
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Center(
                        child: AppText("No Previous Session Found"),
                      )
                    ],
                  ),
                );
              } else if (state is FetchingStudentPreviousSessionFailureState) {
                return SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Center(
                        child: AppText(state.msg ?? ""),
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
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget getMentorsList() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        listOfPreviousSession.length,
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
      child: listOfPreviousSession[index].teacherDetail?.profilePictureUrl ==
                  null ||
              listOfPreviousSession[index]
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
              listOfPreviousSession[index].teacherDetail?.profilePictureUrl ??
                  "",
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
              fit: BoxFit.fill,
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
            Text(
              "${listOfPreviousSession[index].studentRating}",
              style: const TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  void onSessionTap(int index) {
    Navigator.of(context).pushNamed(AppRoutes.studentSessionDetailRoute,
        arguments: SessionDetailArguments(
            id: listOfPreviousSession[index].id.toString(),
            isPrevious: true,
            sessionDetails: listOfPreviousSession[index]));
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
            mentorDetail: listOfPreviousSession[index].teacherDetail!,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const AppText(
                            "Session on: ",
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          AppText(
                            DateTimeUtils.getBirthFormattedDateTime(
                                listOfPreviousSession[index].endDate ??
                                    DateTime.now()),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      AppText(
                        listOfPreviousSession[index].sessionType == "long"
                            ? getSessionTypeWithSlotType(SlotType.long)
                            : getSessionTypeWithSlotType(SlotType.long),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
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
}
