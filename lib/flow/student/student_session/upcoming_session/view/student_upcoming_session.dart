import 'package:flutter/material.dart';
import 'package:newversity/flow/student/student_session/upcoming_session/model/upcoming_session_detail_model.dart';
import 'package:newversity/flow/teacher/bookings/model/session_detail_arguments.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../resources/images.dart';
import '../../../../../themes/colors.dart';

class StudentUpcomingSessionScreen extends StatefulWidget {
  const StudentUpcomingSessionScreen({Key? key}) : super(key: key);

  @override
  State<StudentUpcomingSessionScreen> createState() =>
      _StudentUpcomingSessionScreenState();
}

class _StudentUpcomingSessionScreenState
    extends State<StudentUpcomingSessionScreen> {
  List<UpcomingSessionDetailsModel> listOfMentorsDetails =
      UpcomingSessionDetailsModel.listOfMentorsDetails;

  @override
  Widget build(BuildContext context) {
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

  Widget getMentorsList() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        listOfMentorsDetails.length,
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
      child: listOfMentorsDetails[index].profileImageUrl == null
          ? const AppImage(
              image: ImageAsset.blueAvatar,
            )
          : Image.network(
              listOfMentorsDetails[index].profileImageUrl ?? "",
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
              listOfMentorsDetails[index].rating.toString(),
              style: const TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  onSessionTap() {
    Navigator.of(context).pushNamed(AppRoutes.studentSessionDetailRoute,
        arguments: SessionDetailArguments(
          id: "0",
          isPrevious: false,
        ));
  }

  Widget getMentorDetailsView(int index) {
    return GestureDetector(
      onTap: () => onSessionTap(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 210,
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
                                  listOfMentorsDetails[index].name ?? "",
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
                              listOfMentorsDetails[index].college ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            AppText(
                              listOfMentorsDetails[index].designation ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 220,
                              child: AppText(
                                listOfMentorsDetails[index].certificates ?? "",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppText(
                                  "₹ ${listOfMentorsDetails[index].sessionAmount}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                AppText(
                                  "/ ${listOfMentorsDetails[index].sessionType}",
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
                                      listOfMentorsDetails[index].startTime ??
                                          DateTime.now()) <
                                  1801
                              ? onJoinNowTap()
                              : null,
                          child: Container(
                            width: 150,
                            height: 52,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: getLeftTimeInSeconds(
                                            listOfMentorsDetails[index]
                                                    .startTime ??
                                                DateTime.now()) <
                                        1801
                                    ? AppColors.cyanBlue
                                    : AppColors.grey55),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
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
              )
            ],
          ),
        ),
      ),
    );
  }

  onJoinNowTap() {}

  int getLeftTimeInSeconds(DateTime dateTime) {
    return (dateTime.difference(DateTime.now()).inSeconds);
  }

  bool isTimeUp = false;

  Widget getScheduleLeftTime(int index) {
    int timeLeftInSeconds = getLeftTimeInSeconds(
        listOfMentorsDetails[index].startTime ?? DateTime.now());
    return SlideCountdown(
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
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      separatorStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    );
  }
}
