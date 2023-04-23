import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/student_session/booking_session/bloc/student_session_bloc.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../themes/colors.dart';
import '../../../../../themes/strings.dart';
import '../../../../../utils/date_time_utils.dart';
import '../../../../teacher/availability/data/model/availability_model.dart';
import '../../../../teacher/data/model/teacher_details/teacher_details_model.dart';
import '../model/selected_datetime_model.dart';

class AvailabilityTimingWidget extends StatefulWidget {
  final String? teacherId;
  final List<AvailabilityModel> listOfSessionTimings;

  const AvailabilityTimingWidget(
      {Key? key, required this.teacherId, required this.listOfSessionTimings})
      : super(key: key);

  @override
  State<AvailabilityTimingWidget> createState() =>
      _AvailabilityTimingWidgetState();
}

class _AvailabilityTimingWidgetState extends State<AvailabilityTimingWidget> {
  List<DateTime> currentIntervalSessionTimings = [];
  TeacherDetailsModel? teacherDetails;
  SelectedDateTimeModel? selectedDateTimeModel;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentSessionBloc>(context)
        .add(FetchTeacherDetailsEvent(teacherId: widget.teacherId ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSessionBloc, StudentSessionStates>(
      listener: (context, state) {
        if (state is FetchedTeacherDetailsState) {
          teacherDetails = state.teacherDetails;
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getAvailableTimeHeader(),
            const SizedBox(
              height: 10,
            ),
            teacherDetails != null && teacherDetails?.sessionPricing != null
                ? getPerSessionRate()
                : Container(),
            const SizedBox(
              height: 20,
            ),
            getSessions(),
            const SizedBox(
              height: 20,
            ),
            getNoteContainer(),
            const SizedBox(
              height: 120,
            )
          ],
        );
      },
    );
  }

  Widget getNoteContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appYellow.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.only(left: 12.0, right: 19, top: 11, bottom: 11),
          child: AppText(
            "Note : You cannot book/cancel/reschedule your session within 2 hours before the session time.",
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  List<DateTime> getAddedDateTime(
      DateTime startDateTime, DateTime endDateTime, int timeDiff) {
    List<DateTime> lisOfDateTime = [];
    DateTime tempStartDate = startDateTime;
    while (!tempStartDate.isAfter(endDateTime)) {
      lisOfDateTime.add(tempStartDate);
      tempStartDate = tempStartDate.add(Duration(minutes: timeDiff));
    }
    return lisOfDateTime;
  }

  Widget getNextAvailable() {
    return const Center(
      child: AppText(AppStrings.nextAvailable,
          fontSize: 12,
          color: AppColors.strongCyan,
          fontWeight: FontWeight.w500),
    );
  }

  bool isNotificationChecked = false;

  Widget getNotificationChecker() {
    return Row(
      children: [
        Checkbox(
            value: isNotificationChecked,
            onChanged: (bool? val) {
              isNotificationChecked = val!;
              setState(() {});
            }),
        const SizedBox(
          width: 10,
        ),
        const Text(
          AppStrings.notificationChecker,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget getSessions() {
    return ListView.separated(
      padding: const EdgeInsets.only(right: 16, top: 5),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.listOfSessionTimings.length,
      itemBuilder: (context, index) => getSessionTimingLayout(index),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
    );
  }

  Widget getSessionTimingLayout(int index) {
    currentIntervalSessionTimings = switchEnable
        ? getAddedDateTime(
            widget.listOfSessionTimings[index].startDate ?? DateTime.now(),
            widget.listOfSessionTimings[index].endDate ?? DateTime.now(),
            30)
        : getAddedDateTime(
            widget.listOfSessionTimings[index].startDate ?? DateTime.now(),
            widget.listOfSessionTimings[index].endDate ?? DateTime.now(),
            15);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.grey32),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              "${DateTimeUtils.getTimeInAMOrPM(widget.listOfSessionTimings[index].startDate ?? DateTime.now())}- ${DateTimeUtils.getTimeInAMOrPM(widget.listOfSessionTimings[index].endDate ?? DateTime.now())}",
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: 10,
            ),
            currentIntervalSessionTimings.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 30,
                      runSpacing: 12,
                      children: List.generate(
                        currentIntervalSessionTimings.length,
                        (curIndex) {
                          return getSessionTimingView(curIndex, index);
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  onSelectedSession(int index, SelectedDateTimeModel currentTapedSelectedTime,
      int dateSlotIndex) {
    context.read<StudentSessionBloc>().add(UpdateSelectedDateTimeEvent(
        currentSelectedDateTime: currentTapedSelectedTime));
    context.read<StudentSessionBloc>().availabilityId =
        widget.listOfSessionTimings[dateSlotIndex].availabilityId;
    context.read<StudentSessionBloc>().amount = (switchEnable
        ? teacherDetails?.sessionPricing!["session_type_b"]
        : teacherDetails?.sessionPricing!["session_type_a"]);
  }

  Widget getSessionTimingView(int index, int dateSlotIndex) {
    SelectedDateTimeModel currentTapedSelectedTime = SelectedDateTimeModel(
        dateTime: widget.listOfSessionTimings[dateSlotIndex].startDate,
        currentSelectedDateTime: currentIntervalSessionTimings[index],
        time:
            DateTimeUtils.getTimeInAMOrPM(currentIntervalSessionTimings[index]),
        sessionType: context.read<StudentSessionBloc>().sessionType);
    return Column(
      children: [
        GestureDetector(
          onTap: () =>
              onSelectedSession(index, currentTapedSelectedTime, dateSlotIndex),
          child: Container(
            height: 34,
            width: 83,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                color:
                    context.read<StudentSessionBloc>().selectedDateTimeModel ==
                            currentTapedSelectedTime
                        ? AppColors.lightCyan
                        : AppColors.grey35,
                border: Border.all(width: 0.3, color: AppColors.grey32)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppText(
                  DateTimeUtils.getTimeInAMOrPM(
                      currentIntervalSessionTimings[index]),
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            )),
          ),
        ),
      ],
    );
  }

  Widget getPerSessionRate() {
    return Row(
      children: [
        const AppText(
          AppStrings.perSession,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          switchEnable
              ? "${teacherDetails?.sessionPricing?["session_type_b"]} /-"
              : "${teacherDetails?.sessionPricing?["session_type_a"]} /-",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  bool switchEnable = false;

  Widget getAvailableTimeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          AppStrings.availableTime,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Text(
              AppStrings.fifteenMin,
              style: TextStyle(
                  color:
                      switchEnable ? AppColors.grey32 : AppColors.blackMerlin,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 5,
            ),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                  value: switchEnable,
                  trackColor: AppColors.grey35,
                  thumbColor: AppColors.blackMerlin,
                  activeColor: AppColors.grey35,
                  onChanged: (val) {
                    switchEnable = val;
                    context.read<StudentSessionBloc>().sessionType =
                        switchEnable ? "long" : "short";
                    setState(() {});
                  }),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              AppStrings.thirtyMin,
              style: TextStyle(
                  color:
                      switchEnable ? AppColors.blackMerlin : AppColors.grey32,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
