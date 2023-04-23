import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newversity/common/mentor_personal_detail_card.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/utils/strings.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../flow/student/student_session/booking_session/model/student_session_argument.dart';
import '../navigation/app_routes.dart';
import '../resources/images.dart';
import '../themes/colors.dart';
import '../utils/date_time_utils.dart';
import 'common_widgets.dart';

class MentorDetailCard extends StatefulWidget {
  const MentorDetailCard({Key? key, required this.mentorDetail, this.onTap})
      : super(key: key);
  final TeacherDetailsModel mentorDetail;
  final void Function()? onTap;

  @override
  State<MentorDetailCard> createState() => _MentorCardState();
}

class _MentorCardState extends State<MentorDetailCard> {
  @override
  Widget build(BuildContext context) {
    return getMentorDetailsView();
  }

  Widget getMentorDetailsView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width - 50,
      height: 220,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.grey32),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          MentorPersonalDetailCard(mentorDetail: widget.mentorDetail),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              color: AppColors.mentorsAmountColor,
            ),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: const [
                            AppText(
                              "₹ 250",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            AppText(
                              "/ 30 min session",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            AppText(
                              "₹ 150",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            AppText(
                              "/ 15 min session",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.bookSession,
                            arguments: StudentSessionArgument(
                                teacherId: widget.mentorDetail.teacherId));
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.cyanBlue),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const AppText(
                                "Book Session",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.whiteColor,
                              ),
                              getNextAvailabilityWidget()
                            ],
                          ),
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
    );
  }

  Widget getMentorsProfileImage() {
    return SizedBox(
      // height: MediaQuery.of(context).size.height,
      width: 100,
      child: widget.mentorDetail.profilePictureUrl == null ||
              widget.mentorDetail.profilePictureUrl?.contains("https") == false
          ? const Center(
              child: AppImage(
                image: ImageAsset.blueAvatar,
              ),
            )
          : ClipRRect(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(18)),
              child: Image.network(
                widget.mentorDetail.profilePictureUrl ?? "",
                fit: BoxFit.cover,
                height: 132,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Center(
                    child: AppImage(
                      image: ImageAsset.blueAvatar,
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget getNextAvailabilityWidget() {
    DateTime date = DateTime(2024);
    int timeLeftInSeconds = getLeftTimeInSeconds(date);
    if (timeLeftInSeconds > DateTimeUtils.secondsInOneDay) {
      String weekday = DateFormat('EEEE').format(date);
      return AppText(
        "Available: Next $weekday",
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.whiteColor,
      );
    }

    return Row(
      children: [
        const AppText(
          "Available in:",
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppColors.whiteColor,
        ),
        getScheduleLeftTime(timeLeftInSeconds),
      ],
    );
  }

  Widget getScheduleLeftTime(int timeLeftInSeconds) {
    return SlideCountdown(
      duration: Duration(seconds: timeLeftInSeconds),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      slideDirection: SlideDirection.down,
      durationTitle: DurationTitle.id(),
      separator: ":",
      textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.whiteColor),
      separatorStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppColors.whiteColor),
    );
  }

  int getLeftTimeInSeconds(DateTime dateTime) {
    return (dateTime.difference(DateTime.now()).inSeconds);
  }
}
