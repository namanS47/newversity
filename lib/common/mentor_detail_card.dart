import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:newversity/common/mentor_personal_detail_card.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/utils/enums.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: MediaQuery.of(context).size.width - 50,
      // height: 220,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.grey32),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          MentorPersonalDetailCard(mentorDetail: widget.mentorDetail, showScopeTags: true,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Container(
                    color: AppColors.peacefulGreen,
                    child: widget.mentorDetail.nextAvailable != null
                        ? getNextAvailabilityWidget()
                        : Container(),
                  ),
                  const Spacer(),
                  getBookSlotCta()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getBookSlotCta() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.bookSession,
            arguments: StudentSessionArgument(
                teacherId: widget.mentorDetail.teacherId,
                pageIndex: 1));
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.cyanBlue),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "₹ ${widget.mentorDetail.sessionPricing?[SlotType.long.toString().split(".")[1]]?.toInt()}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.whiteColor
                  ),
                ),
                const Text(
                  "per session",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 8,
                      color: AppColors.whiteColor
                  ),
                ),
              ],
            ),
            const VerticalDivider(color: AppColors.whiteColor, indent: 16, endIndent: 16, thickness: 2,),
            const AppText(
              "Book a Slot",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget getNextAvailabilityWidget() {
    String weekday = "";
    if (!DateTimeUtils().isDaySame(widget.mentorDetail.nextAvailable!, DateTime.now())) {
      weekday = DateFormat('dd MMM').format(widget.mentorDetail.nextAvailable!);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3, left: 6),
      child: Row(
        children: [
          SvgPicture.asset(ImageAsset.clockCircle),
          const SizedBox(
            width: 6,
          ),
          RichText(
              text: const TextSpan(children: [
                TextSpan(
                    text: "Available - ",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackRussian,
                    ))
              ])),
          AppText(
            weekday.isNotEmpty
                ? "$weekday  "
                : "${DateTimeUtils.getTimeInAMOrPM(
                widget.mentorDetail.nextAvailable!)}  ",
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.blackRussian,
          ),
        ],
      ),
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
      onChanged: (value) {
        if (value.inSeconds < 1801) {
          setState(() {});
        }
      },
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
