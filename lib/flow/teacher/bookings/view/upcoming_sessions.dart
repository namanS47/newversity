import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/bookings/bloc/upcoming_session_bloc/upcoming_session_bloc.dart';
import 'package:newversity/flow/teacher/bookings/model/session_detail_arguments.dart';
import 'package:newversity/flow/teacher/bookings/view/bottom_sheets/sort_by_bottom_sheet_upcoming_session.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/enums.dart';

import '../../../../common/common_widgets.dart';
import '../../../../utils/date_time_utils.dart';
import '../../home/model/session_response_model.dart';

class UpcomingSessions extends StatefulWidget {
  const UpcomingSessions({Key? key}) : super(key: key);

  @override
  State<UpcomingSessions> createState() => _UpcomingSessionsState();
}

class _UpcomingSessionsState extends State<UpcomingSessions> {
  List<SessionDetailsResponse> listOfSessionDetailResponse = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UpcomingSessionBloc>(context).add(
        FetchAllUpcomingSessionsEvent(
            type: getSessionType(SessionType.upcoming)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ), // getTimeFilter(),
        const SizedBox(
          height: 10,
        ),
        getListOfUpcomingSessions(),
      ],
    );
  }

  Widget getListOfUpcomingSessions() {
    return BlocConsumer<UpcomingSessionBloc, UpcomingSessionStates>(
      listener: (context, state) {
        if (state is FetchedUpcomingSessionState && state.sessionDetailResponse != null) {
          listOfSessionDetailResponse = state.sessionDetailResponse!;
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return listOfSessionDetailResponse.isNotEmpty
                ? Wrap(
                    spacing: 15,
                    runSpacing: 12,
                    children: List.generate(
                      listOfSessionDetailResponse.length,
                      (curIndex) {
                        return getUpComingSessionDataView(curIndex);
                      },
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 300,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: AppText(
                              "Data not Found",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
      },
    );
  }

  Widget getStartingTime(
      int hour, int min, int sec, bool crossedThreshHoldTime) {
    return Row(
      children: [
        const AppText(
          "Starts at: ",
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        AppText(
          hour.toString(),
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        AppText(
          "H",
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: crossedThreshHoldTime
              ? AppColors.redColorShadow400
              : AppColors.strongGreen,
        ),
        AppText(
          ":$min",
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        AppText(
          "M",
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: crossedThreshHoldTime
              ? AppColors.redColorShadow400
              : AppColors.strongGreen,
        ),
        AppText(
          ":$sec",
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        AppText(
          "S",
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: crossedThreshHoldTime
              ? AppColors.redColorShadow400
              : AppColors.strongGreen,
        ),
      ],
    );
  }

  //TODO: Naman remove force unwrapping
  onProfileTap(int index) {
    Navigator.of(context).pushNamed(AppRoutes.sessionDetails,
        arguments: SessionDetailArguments(
            id: listOfSessionDetailResponse[index].id!, isPrevious: false));
  }

  Widget getUpComingSessionDataView(int index) {
    return GestureDetector(
      onTap: () => onProfileTap(index),
      child: Row(
        children: [
          SizedBox(
            height: 66,
            width: 66,
            child: CircleAvatar(
              radius: 200,
              child: AppImage(
                image: listOfSessionDetailResponse[index].paymentId ??
                    ImageAsset.blueAvatar,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    listOfSessionDetailResponse[index].studentId ?? "",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  AppText(
                    "Starts at : ${getTimeText(index)}",
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.cyanBlue,
                  )
                  // getStartingTime(01, 20, 17,
                  //     listOfUpComingSessionData[index].crossedThresholdTime),
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              AppText(
                listOfSessionDetailResponse[index].agenda ??
                    "This is Agenda Section",
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    listOfSessionDetailResponse[index].id ??
                        "This is Qualifucation Section",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  getJoinNowCTA(index),
                ],
              ),
              const SizedBox(
                height: 11,
              ),
              getDividerContainer(),
            ],
          ))
        ],
      ),
    );
  }

  Widget getDividerContainer() {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        color: AppColors.grey32,
      ),
    );
  }

  int getLeftTimeInSeconds(DateTime dateTime) {
    return (dateTime.difference(DateTime.now()).inSeconds);
  }

  String getTimeText(int index) {
    String text = "";
    text =
        "${DateTimeUtils.getTimeInAMOrPM(listOfSessionDetailResponse[index].startDate ?? DateTime.now())} - ${DateTimeUtils.getTimeInAMOrPM(listOfSessionDetailResponse[index].endDate ?? DateTime.now())}";
    return text;
  }

  onTapJoinNow() {}

  Widget getJoinNowCTA(int index) {
    return GestureDetector(
      onTap: () =>
          getLeftTimeInSeconds(listOfSessionDetailResponse[index].startDate!) <
                  1801
              ? onTapJoinNow()
              : null,
      child: Container(
        height: 32,
        width: 100,
        decoration: BoxDecoration(
          color: getLeftTimeInSeconds(
                      listOfSessionDetailResponse[index].startDate!) <
                  1801
              ? AppColors.cyanBlue
              : AppColors.grey50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: AppText(
              "JOIN NOW",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: getLeftTimeInSeconds(
                          listOfSessionDetailResponse[index].startDate!) <
                      1801
                  ? AppColors.whiteColor
                  : AppColors.grey35,
            ),
          ),
        ),
      ),
    );
  }

  Widget getTimeFilter() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: context.read<UpcomingSessionBloc>().timeFilter.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return filterContainer();
          } else if (index == 1) {
            return allContainer();
          }
          return getTimerFilterView(index - 2);
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 18),
      ),
    );
  }

  onTapFilterChip(int index) {
    BlocProvider.of<UpcomingSessionBloc>(context)
        .add(OnSelectTimeRangeChipEvent(index: index));
  }

  Widget getTimerFilterView(int index) {
    return GestureDetector(
      onTap: () => onTapFilterChip(index),
      child: Center(
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color:
                context.read<UpcomingSessionBloc>().selectedTimeFilterIndex ==
                        index
                    ? AppColors.primaryColor
                    : AppColors.whiteColor,
            border: Border.all(width: 1, color: AppColors.grey50),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
              child: AppText(
                context.read<UpcomingSessionBloc>().timeFilter[index],
                fontSize: 14,
                color: context
                            .read<UpcomingSessionBloc>()
                            .selectedTimeFilterIndex ==
                        index
                    ? AppColors.whiteColor
                    : AppColors.blackMerlin,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  onFilterTap() {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return AppAnimatedBottomSheet(
              bottomSheetWidget: BlocProvider<UpcomingSessionBloc>(
                  create: (context) => UpcomingSessionBloc(),
                  child: const SortByForUpcomingSessionBottomSheet()));
          // your stateful widget
        });
  }

  Widget filterContainer() {
    return GestureDetector(
      onTap: () => onFilterTap(),
      child: Center(
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            border: Border.all(width: 1, color: AppColors.grey35),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
              child: AppImage(image: ImageAsset.filter),
            ),
          ),
        ),
      ),
    );
  }

  onTapAllTimeChip() {
    BlocProvider.of<UpcomingSessionBloc>(context)
        .add(OnSelectTimeRangeChipEvent(index: -1));
  }

  Widget allContainer() {
    return GestureDetector(
      onTap: () => onTapAllTimeChip(),
      child: Center(
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color:
                context.read<UpcomingSessionBloc>().selectedTimeFilterIndex ==
                        -1
                    ? AppColors.primaryColor
                    : AppColors.whiteColor,
            border: Border.all(width: 1, color: AppColors.grey35),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
              child: AppText(
                "All",
                fontSize: 14,
                color: context
                            .read<UpcomingSessionBloc>()
                            .selectedTimeFilterIndex ==
                        -1
                    ? AppColors.whiteColor
                    : AppColors.blackMerlin,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
