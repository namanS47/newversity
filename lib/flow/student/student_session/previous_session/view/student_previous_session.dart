import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocConsumer<StudentPreviousSessionBloc,
        StudentPreviousSessionState>(
      buildWhen: (previous, current) => isRebuildWidgetState(current),
      listenWhen: (previous, current) => isRebuildWidgetState(current),
      listener: (context, state) {
        if (state is FetchedStudentPreviousSessionState) {
          listOfPreviousSession = state.listOfPreviousSession;
        }
      },
      builder: (context, state) {
        if (state is FetchingStudentPreviousSessionState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.cyanBlue,
                  ),
                )
              ],
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
              null
          ? const AppImage(
              image: ImageAsset.blueAvatar,
            )
          : Image.network(
              listOfPreviousSession[index].teacherDetail?.profilePictureUrl ??
                  "",
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

  onSessionTap(int index) {
    Navigator.of(context).pushNamed(AppRoutes.studentSessionDetailRoute,
        arguments: SessionDetailArguments(
          id: listOfPreviousSession[index].id.toString(),
          isPrevious: true,
        ));
  }

  Widget getMentorDetailsView(int index) {
    return GestureDetector(
      onTap: () => onSessionTap(index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 175,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.grey32),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getMentorsProfileImage(index),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  listOfPreviousSession[index]
                                          .teacherDetail
                                          ?.name ??
                                      "",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                getRateContainer(index),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppText(
                              listOfPreviousSession[index]
                                      .teacherDetail
                                      ?.tags.toString() ??
                                  "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            AppText(
                              listOfPreviousSession[index]
                                      .teacherDetail
                                      ?.designation ??
                                  "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 220,
                              child: AppText(
                                listOfPreviousSession[index]
                                        .teacherDetail
                                        ?.education ??
                                    "",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColors.mentorsAmountColor,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
