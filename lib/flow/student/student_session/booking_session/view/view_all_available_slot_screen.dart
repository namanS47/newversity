import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/date_availability_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/student_session_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/view/avaiblity_timing_widget.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../../common/common_utils.dart';
import '../../../../../utils/date_time_utils.dart';
import '../../../../teacher/availability/data/model/availability_model.dart';
import '../../../../teacher/availability/data/model/fetch_availability_request_model.dart';
import '../../../../teacher/data/model/teacher_details/teacher_details_model.dart';
import '../bloc/student_session_bloc.dart';
import '../model/session_bookin_argument.dart';

class ViewAllAvailableSlotScreen extends StatefulWidget {
  final StudentSessionArgument studentSessionArgument;

  const ViewAllAvailableSlotScreen(
      {Key? key, required this.studentSessionArgument})
      : super(key: key);

  @override
  State<ViewAllAvailableSlotScreen> createState() =>
      _ViewAllAvailableSlotScreenState();
}

class _ViewAllAvailableSlotScreenState
    extends State<ViewAllAvailableSlotScreen> {
  final DateTime todayDate = DateTime.now();
  Map<String, List<AvailabilityModel>> toadyDateTime = {};
  Map<String, List<AvailabilityModel>> lisOfAvailability = {};
  List<AvailabilityModel> lisOfTimings = [];
  bool isCalenderView = false;
  TeacherDetailsModel? teacherDetails;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentSessionBloc>(context).add(
        FetchTeacherAvailabilityEvent(
            fetchAvailabilityRequestModel: FetchAvailabilityRequestModel(
                teacherId: widget.studentSessionArgument.teacherId)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSessionBloc, StudentSessionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: AppColors.lightCyan),
              ),
              SafeArea(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getAppHeader(),
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              primary: true,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  isCalenderView
                                      ? getCalenderView()
                                      : getDateListWidget(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Expanded(child: Container()),
                        getConfirmationCTA()
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  bool _isRebuildWidgetAvailabilityState(StudentSessionStates state) {
    var elm = state is FetchingTeacherAvailabilityState ||
        state is FetchedTeacherAvailabilityState ||
        state is NotTeacherSlotFoundState;
    return elm;
  }

  Widget getDateListWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: BlocConsumer<StudentSessionBloc, StudentSessionStates>(
            listenWhen: (previous, current) =>
                _isRebuildWidgetAvailabilityState(current),
            buildWhen: (previous, current) =>
                _isRebuildWidgetAvailabilityState(current),
            listener: (context, state) {
              if (state is FetchedTeacherAvailabilityState) {
                lisOfAvailability =
                    context.read<StudentSessionBloc>().dateTimeMap;
              }
            },
            builder: (context, state) {
              if (state is FetchedTeacherAvailabilityState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fetchListOfDataContainsTodayDateAvailability()
                        ? getTodayContainer()
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    getUpcomingContainers(),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                );
              }
              if (state is NotTeacherSlotFoundState) {
                return Column(
                  children: const [
                    SizedBox(
                      height: 500,
                      child: Center(
                        child: NoResultFoundScreen(
                          message: "No teacher slot available for this teacher",
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: const [
                  SizedBox(
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.cyanBlue,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool _isRebuildWidgetState(StudentSessionStates state) {
    var elm = state is FetchingTeacherSessionTimingsState ||
        state is FetchingTeacherSessionTimingsFailureState ||
        state is FetchedTeacherSessionTimingsState;
    return elm;
  }

  Widget getCalenderView() {
    return Column(
      children: [
        getCalenderWidget(),
        const SizedBox(
          height: 20,
        ),
        BlocConsumer<StudentSessionBloc, StudentSessionStates>(
          buildWhen: (previous, current) => _isRebuildWidgetState(current),
          listenWhen: (previous, current) => _isRebuildWidgetState(current),
          listener: (context, state) {
            if (state is FetchedTeacherSessionTimingsState) {
              lisOfTimings = state.availabilityList;
            }
          },
          builder: (context, state) {
            if (state is FetchedTeacherSessionTimingsState) {
              return Container(
                height: MediaQuery.of(context).size.height +
                    lisOfTimings.length * 100,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: AvailabilityTimingWidget(
                      teacherId: widget.studentSessionArgument.teacherId ?? "",
                      listOfSessionTimings: lisOfTimings,
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: AppColors.whiteColor),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.cyanBlue,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget getConfirmationCTA() {
    return Visibility(
      visible: isCalenderView,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: AppCta(
          color:
              context.read<StudentSessionBloc>().selectedDateTimeModel != null
                  ? AppColors.cyanBlue
                  : AppColors.grey32,
          onTap: () =>
              context.read<StudentSessionBloc>().selectedDateTimeModel != null
                  ? onConfirmTap()
                  : null,
          text: AppStrings.confirm,
        ),
      ),
    );
  }

  Widget getCalenderWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: AppColors.whiteColor,
          height: 250,
          child: SfCalendar(
            monthCellBuilder:
                (BuildContext buildContext, MonthCellDetails details) {
              return Center(
                child: Container(
                  height: 27,
                  width: 27,
                  decoration: BoxDecoration(
                      color: compareDate(
                              context.read<StudentSessionBloc>().selectedDate,
                              details.date)
                          ? AppColors.strongCyan
                          : AppColors.whiteColor,
                      shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      details.date.day.toString(),
                      style: TextStyle(
                        color: compareDate(
                                context.read<StudentSessionBloc>().selectedDate,
                                details.date)
                            ? AppColors.whiteColor
                            : todayDate.day > details.date.day
                                ? AppColors.grey55
                                : AppColors.cyanBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
            onTap: (val) {
              setState(() {
                context.read<StudentSessionBloc>().selectedDate =
                    val.date ?? todayDate;
                BlocProvider.of<StudentSessionBloc>(context).add(
                    FetchTeacherSessionTimingsEvent(
                        fetchAvailabilityRequestModel:
                            FetchAvailabilityRequestModel(
                                teacherId:
                                    widget.studentSessionArgument.teacherId,
                                date: context
                                    .read<StudentSessionBloc>()
                                    .selectedDate)));
              });
            },
            minDate: DateTime.now(),
            view: CalendarView.month,
            showNavigationArrow: true,
            monthViewSettings: const MonthViewSettings(
              numberOfWeeksInView: 6,
              showTrailingAndLeadingDates: false,
              dayFormat: "EEE",
            ),
            selectionDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.transparent),
            ),
            todayTextStyle: const TextStyle(color: Colors.black),
            cellBorderColor: Colors.transparent,
            todayHighlightColor: Colors.transparent,
            headerHeight: 50,
            headerStyle: const CalendarHeaderStyle(
              backgroundColor: AppColors.cyanBlue,
              textStyle: TextStyle(
                color: AppColors.whiteColor,
              ),
            ),
            viewHeaderStyle: const ViewHeaderStyle(),
          ),
        ),
      ),
    );
  }

  bool compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  bool fetchListOfDataContainsTodayDateAvailability() {
    for (var element in context.read<StudentSessionBloc>().dateTimeMap.keys) {
      if (!(DateTimeUtils.getDateTime(element))
          .isAfter(DateTime.now().add(const Duration(hours: 24)))) {
        toadyDateTime[element] =
            context.read<StudentSessionBloc>().dateTimeMap[element]!;
        lisOfAvailability.remove(element);
        return true;
      }
    }
    return false;
  }

  Widget getUpcomingContainers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Upcoming Availability",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        getUpcomingDateList()
      ],
    );
  }

  Widget getUpcomingDateList() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(
          lisOfAvailability.length, (index) => getDateContainer(index)),
    );
  }

  Widget getTodayContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Today",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        getTodayList(),
      ],
    );
  }

  onTodaySlotDateType() {
    Navigator.of(context).pushNamed(AppRoutes.dateWiseSlotRoute,
        arguments: DateAvailabilityArgument(
            teacherId: widget.studentSessionArgument.teacherId,
            currentDateTime:
                (DateTimeUtils.getDateTime(toadyDateTime.keys.elementAt(0)))));
  }

  Widget getTodayList() {
    return InkWell(
      onTap: () => onTodaySlotDateType(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: AppColors.grey35)),
          child: Row(
            children: [
              Container(
                width: 93,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        DateTimeUtils.getDayName(DateTimeUtils.getDateTime(
                            toadyDateTime.keys.elementAt(0))),
                        color: AppColors.whiteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      AppText(
                        "${(DateTimeUtils.getDateTime(toadyDateTime.keys.elementAt(0))).day} ${DateTimeUtils.months[DateTimeUtils.getCurrentMonth(DateTimeUtils.getDateTime(toadyDateTime.keys.elementAt(0))) - 1]}",
                        color: AppColors.whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.grey32.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(
                        "${DateTimeUtils.getTotalDuration(toadyDateTime[toadyDateTime.keys.elementAt(0)]!)} available",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  onSlotDateTap(int index) {
    Navigator.of(context).pushNamed(
      AppRoutes.dateWiseSlotRoute,
      arguments: DateAvailabilityArgument(
          teacherId: widget.studentSessionArgument.teacherId,
          currentDateTime: DateTimeUtils.getDateTime(
              lisOfAvailability.keys.elementAt(index))),
    );
  }

  Widget getDateContainer(int index) {
    return InkWell(
      onTap: () => onSlotDateTap(index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: AppColors.grey35)),
          child: Row(
            children: [
              Container(
                width: 93,
                decoration: BoxDecoration(
                  color: AppColors.lightCyan.withOpacity(0.35),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        DateTimeUtils.getDayName(DateTimeUtils.getDateTime(
                            lisOfAvailability.keys.elementAt(index))),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      AppText(
                          "${DateTimeUtils.getDateTime(lisOfAvailability.keys.elementAt(index)).day} ${DateTimeUtils.months[DateTimeUtils.getCurrentMonth(DateTimeUtils.getDateTime(lisOfAvailability.keys.elementAt(index))) - 1]}",
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.grey32.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(
                        "${DateTimeUtils.getTotalDuration(lisOfAvailability[context.read<StudentSessionBloc>().dateTimeMap.keys.elementAt(index)] ?? [
                              AvailabilityModel()
                            ])} Available",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget getAppHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: AppImage(image: ImageAsset.arrowBack)),
                  )),
              const SizedBox(
                width: 10,
              ),
              const AppText(
                "View all available slots",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )
            ],
          ),
          InkWell(
            onTap: () => onCalenderViewTap(),
            child: AppImage(
                image: isCalenderView
                    ? ImageAsset.calenderUp
                    : ImageAsset.calenderIcon),
          ),
        ],
      ),
    );
  }

  onCalenderViewTap() {
    isCalenderView = !isCalenderView;
    if (isCalenderView) {
      BlocProvider.of<StudentSessionBloc>(context).add(
          FetchTeacherSessionTimingsEvent(
              fetchAvailabilityRequestModel: FetchAvailabilityRequestModel(
                  teacherId: widget.studentSessionArgument.teacherId,
                  date: context.read<StudentSessionBloc>().selectedDate)));
    } else {
      BlocProvider.of<StudentSessionBloc>(context).add(
          FetchTeacherAvailabilityEvent(
              fetchAvailabilityRequestModel: FetchAvailabilityRequestModel(
                  teacherId: widget.studentSessionArgument.teacherId)));
    }
    setState(() {});
  }

  onConfirmTap() {
    Navigator.of(context).pushNamed(
      AppRoutes.bookingConfirmation,
      arguments: SessionBookingArgument(
          CommonUtils().getLoggedInUser(),
          widget.studentSessionArgument.teacherId ?? "",
          context
                  .read<StudentSessionBloc>()
                  .selectedDateTimeModel
                  ?.currentSelectedDateTime ??
              DateTime.now(),
          (context
                      .read<StudentSessionBloc>()
                      .selectedDateTimeModel
                      ?.currentSelectedDateTime ??
                  DateTime.now())
              .add(Duration(
                  minutes:
                      context.read<StudentSessionBloc>().sessionType == "short"
                          ? 15
                          : 30)),
          context.read<StudentSessionBloc>().sessionType ?? "",
          context.read<StudentSessionBloc>().amount ?? 0,
          context.read<StudentSessionBloc>().availabilityId ?? ""),
    );
  }
}
