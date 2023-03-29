import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/availability/availability_bloc/availability_bloc.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/date_time_utils.dart';
import 'package:newversity/utils/enums.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../utils/strings.dart';
import 'data/availability_arguments.dart';

class AvailabilityRoute extends StatefulWidget {
  const AvailabilityRoute({Key? key}) : super(key: key);

  @override
  State<AvailabilityRoute> createState() => _AvailabilityRouteState();
}

class _AvailabilityRouteState extends State<AvailabilityRoute> {
  final DateTime todayDate = DateTime.now();
  late Size size;

  @override
  void initState() {
    context
        .read<AvailabilityBloc>()
        .add(FetchAvailabilityArgumentEvent(date: todayDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCalendarWidget(),
              const SizedBox(
                height: 24,
              ),
              BlocBuilder<AvailabilityBloc, AvailabilityState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      updateAvailabilityWidget(),
                      allAvailabilityWidget()
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget updateAvailabilityWidget() {
    return Visibility(
      visible: context.read<AvailabilityBloc>().showUpdateAvailabilityWidget,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            availableTimeWidget(),
            selectedDateWidget(),
            const SizedBox(
              height: 16,
            ),
            getAvailabilityListWidget(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getCancelUpdateCta(),
                const Spacer(),
                getAddAvailabilityCta()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget allAvailabilityWidget() {
    return Visibility(
      visible: !context.read<AvailabilityBloc>().showUpdateAvailabilityWidget,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            availableTimeWidget(),
            selectedDateWidget(),
            BlocBuilder<AvailabilityBloc, AvailabilityState>(
              builder: (context, state) {
                if (state is FetchAvailabilityLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is FetchAvailabilitySuccessState) {
                  if (state.availabilityList.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          Column(
                            children: state.availabilityList
                                .map((availability) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 12),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.grey32),
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      child: Row(
                                        children: [
                                          Text(
                                            StringsUtils
                                                .getAvailabilityStartAndEndTimeString(
                                              context,
                                              availability.startDate!,
                                              availability.endDate!,
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${availability.totalBooked ?? 0} Booked",
                                            style: TextStyle(
                                                color:
                                                    (availability.totalBooked ??
                                                                0) ==
                                                            0
                                                        ? AppColors.strongRed
                                                        : AppColors.strongGreen,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(width: 8),
                                          // Container(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       horizontal: 16, vertical: 8),
                                          //   decoration: BoxDecoration(
                                          //     color: AppColors.colorGreen,
                                          //     borderRadius:
                                          //         BorderRadius.circular(12),
                                          //   ),
                                          //   child: const Center(
                                          //     child: Text(
                                          //       "Cancel Slot",
                                          //       style: TextStyle(
                                          //         fontSize: 12,
                                          //         color: AppColors.whiteColor,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                          AppCta(
                            text: "Add Availability",
                            onTap: () => context
                                .read<AvailabilityBloc>()
                                .add(AddAvailabilityArgumentsEvent()),
                          )
                        ],
                      ),
                    );
                  } else {
                    return addAvailabilityWidget();
                  }
                }
                return addAvailabilityWidget();
              },
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget getCancelUpdateCta() {
    return AppCta(
      text: "Cancel",
      width: (size.width - 32 - 16) / 2,
      onTap: () {
        context.read<AvailabilityBloc>().showUpdateAvailabilityWidget = false;
        context.read<AvailabilityBloc>().add(FetchAvailabilityArgumentEvent(
            date: context.read<AvailabilityBloc>().selectedDate));
      },
    );
  }

  Widget getAddAvailabilityCta() {
    bool isLoading = false;
    return BlocConsumer<AvailabilityBloc, AvailabilityState>(
      listener: (context, state) {
        if (state is SomethingWentWrongState) {
          isLoading = false;
          CommonWidgets.snackBarWidget(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is SaveAvailabilitySuccessSate) {
          isLoading = false;
        } else if (state is SomethingWentWrongState) {
          isLoading = false;
        } else if (state is SaveAvailabilityLoadingSate) {
          isLoading = true;
        }
        return AppCta(
          isLoading: isLoading,
          width: (size.width - 32 - 16) / 2,
          onTap: () {
            if (context.read<AvailabilityBloc>().availabilityList.isEmpty ||
                !context.read<AvailabilityBloc>().isAddedAvailabilityValid()) {
              CommonWidgets.snackBarWidget(context, "Please add availability");
            } else {
              context.read<AvailabilityBloc>().add(SaveAvailabilityEvent());
            }
          },
          text: "Save",
        );
      },
    );
  }

  Widget getAvailabilityListWidget() {
    return BlocBuilder<AvailabilityBloc, AvailabilityState>(
        builder: (context, AvailabilityState state) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: context.read<AvailabilityBloc>().availabilityList.length,
        itemBuilder: (context, index) {
          return SelectSlotDuration(
            arguments: context.read<AvailabilityBloc>().availabilityList[index],
            index: index,
          );
        },
      );
    });
  }

  Widget availableTimeWidget() {
    return Row(
      children: [
        const Text(
          "Available times",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Spacer(),
        InkWell(
          onTap: () => context
              .read<AvailabilityBloc>()
              .add(AddAvailabilityArgumentsEvent()),
          child: const Icon(
            Icons.add,
            color: AppColors.cyanBlue,
          ),
        )
      ],
    );
  }

  Widget addAvailabilityWidget() {
    return Container(
      height: 102,
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: AppColors.grey35, borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => context
            .read<AvailabilityBloc>()
            .add(AddAvailabilityArgumentsEvent()),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.add,
                color: AppColors.cyanBlue,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Add your Availability",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedDateWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Icon(Icons.check_box),
          const SizedBox(
            width: 8,
          ),
          Text(
            DateTimeUtils.getBirthFormattedDateTime(
                context.read<AvailabilityBloc>().selectedDate),
            style: const TextStyle(fontSize: 16, color: AppColors.blackRussian),
          )
        ],
      ),
    );
  }

  Widget getCalendarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.lightCyan,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Availability",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          ClipRRect(
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
                                  context.read<AvailabilityBloc>().selectedDate,
                                  details.date)
                              ? AppColors.strongCyan
                              : AppColors.whiteColor,
                          shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          details.date.day.toString(),
                          style: TextStyle(
                            color: compareDate(
                                    context
                                        .read<AvailabilityBloc>()
                                        .selectedDate,
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
                    context.read<AvailabilityBloc>().selectedDate =
                        val.date ?? todayDate;
                    context.read<AvailabilityBloc>().add(
                        FetchAvailabilityArgumentEvent(
                            date: val.date ?? todayDate));
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
          const SizedBox(
            height: 12,
          ),
          slotSelectionWidget()
        ],
      ),
    );
  }

  Widget slotSelectionWidget() {
    return BlocBuilder<AvailabilityBloc, AvailabilityState>(
      builder: (context, state) {
        return Visibility(
          visible:
              context.read<AvailabilityBloc>().showUpdateAvailabilityWidget,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select session type",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    slotTypeWidget(SlotType.short),
                    const Spacer(),
                    slotTypeWidget(SlotType.long),
                    const Spacer(),
                    slotTypeWidget(SlotType.both),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget slotTypeWidget(SlotType slotType) {
    bool isSelected = slotType == context.read<AvailabilityBloc>().sessionType;
    String slotString = "";
    switch (slotType) {
      case SlotType.short:
        slotString = "15 mins";
        break;
      case SlotType.long:
        slotString = "30 mins";
        break;
      case SlotType.both:
        slotString = "Both";
    }
    return InkWell(
      onTap: () => setState(() {
        context.read<AvailabilityBloc>().sessionType = slotType;
      }),
      child: Row(
        children: [
          isSelected
              ? const Icon(
                  Icons.radio_button_checked,
                  color: AppColors.cyanBlue,
                )
              : const Icon(
                  Icons.radio_button_off,
                  color: AppColors.grey60,
                ),
          const SizedBox(
            width: 10,
          ),
          Text(slotString)
        ],
      ),
    );
  }

  bool compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}

class SelectSlotDuration extends StatefulWidget {
  const SelectSlotDuration(
      {Key? key, required this.arguments, required this.index})
      : super(key: key);
  final AvailabilityArguments arguments;
  final int index;

  @override
  State<SelectSlotDuration> createState() => _SelectSlotDurationState();
}

class _SelectSlotDurationState extends State<SelectSlotDuration> {
  final List<TimeOfDay> allTimes = DateTimeUtils.getAllAvailableTime();
  int start = 0;
  int end = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grey32)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "From",
                style: TextStyle(
                  color: AppColors.colorBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              selectStartTimeWidget()
            ],
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              "-",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "To",
                style: TextStyle(
                  color: AppColors.colorBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              selectEndTimeWidget()
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              context
                  .read<AvailabilityBloc>()
                  .add(RemoveAvailabilityArgumentsEvent(index: widget.index));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Icon(
                Icons.delete,
                color: widget.arguments.selectedStartTime != null &&
                        widget.arguments.selectedEndTime != null
                    ? AppColors.lightRed
                    : AppColors.grey60,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget selectStartTimeWidget() {
    return SizedBox(
      height: 40,
      width: 115,
      child: AppDropdownButton(
        hint: "Enter",
        value: widget.arguments.selectedStartTime != null
            ? DateTimeUtils.getTimeFormat(
                widget.arguments.selectedStartTime!, context)
            : null,
        dropdownItems: allTimes
            .map((e) => DateTimeUtils.getTimeFormat(e, context))
            .toList(),
        onChanged: (val) => setState(() {
          final timeOFDay = DateTimeUtils.stringToTimeOfDay(val!);
          if (widget.arguments.selectedEndTime != null &&
              timeOFDay.hour * 60 + timeOFDay.minute >=
                  widget.arguments.selectedEndTime!.hour * 60 +
                      widget.arguments.selectedEndTime!.minute) {
            widget.arguments.selectedEndTime = null;
          }
          widget.arguments.selectedStartTime = timeOFDay;
        }),
        buttonPadding: const EdgeInsets.only(left: 8),
        dropdownWidth: 115,
        buttonDecoration: BoxDecoration(
          border: Border.all(color: AppColors.grey32),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.grey35,
        ),
        hintAlignment: Alignment.center,
      ),
    );
  }

  Widget selectEndTimeWidget() {
    final List<TimeOfDay> availableTimes =
        DateTimeUtils.getSelectedAvailableTime(
            widget.arguments.selectedStartTime ?? allTimes[0]);
    return SizedBox(
      height: 40,
      width: 115,
      child: AppDropdownButton(
        hint: "Enter",
        value: widget.arguments.selectedEndTime != null
            ? DateTimeUtils.getTimeFormat(
                widget.arguments.selectedEndTime!, context)
            : null,
        dropdownItems: availableTimes
            .map((e) => DateTimeUtils.getTimeFormat(e, context))
            .toList(),
        onChanged: (val) => setState(() {
          widget.arguments.selectedEndTime =
              DateTimeUtils.stringToTimeOfDay(val!);
        }),
        buttonPadding: const EdgeInsets.only(left: 8),
        dropdownWidth: 115,
        buttonDecoration: BoxDecoration(
          border: Border.all(color: AppColors.grey32),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.grey35,
        ),
        hintAlignment: Alignment.center,
      ),
    );
  }
}
