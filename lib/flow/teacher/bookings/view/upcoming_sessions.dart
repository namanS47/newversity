import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/student_session/my_session/model/session_detail_response_model.dart';
import 'package:newversity/flow/teacher/bookings/bloc/upcoming_session_bloc/upcoming_session_bloc.dart';
import 'package:newversity/flow/teacher/bookings/model/session_detail_arguments.dart';
import 'package:newversity/flow/teacher/bookings/view/bottom_sheets/sort_by_bottom_sheet_upcoming_session.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/enums.dart';
import 'package:newversity/utils/strings.dart';

import '../../../../common/common_widgets.dart';
import '../../../../utils/date_time_utils.dart';

class UpcomingSessions extends StatefulWidget {
  const UpcomingSessions({Key? key}) : super(key: key);

  @override
  State<UpcomingSessions> createState() => _UpcomingSessionsState();
}

class _UpcomingSessionsState extends State<UpcomingSessions> {
  List<SessionDetailResponseModel> listOfSessionDetailResponse = [];

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
        if (state is FetchedUpcomingSessionState &&
            state.sessionDetailResponse != null) {
          listOfSessionDetailResponse = state.sessionDetailResponse!;
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is FetchingUpcomingSessionState) {
          return getProgressIndicator();
        }
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

  Widget getProgressIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.cyanBlue,
              ),
            ),
          ),
        )
      ],
    );
  }

  //TODO: Naman remove force unwrapping
  onProfileTap(int index) {
    Navigator.of(context).pushNamed(AppRoutes.sessionDetails,
        arguments: SessionDetailArguments(
            id: listOfSessionDetailResponse[index].id!, isPrevious: false));
  }

  Widget getStudentProfilePic(String? profileUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 66,
        width: 66,
        child: profileUrl == null
            ? const AppImage(
                image: ImageAsset.blueAvatar,
              )
            : Image.network(
                profileUrl ?? "",
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
      ),
    );
  }

  Widget getUpComingSessionDataView(int index) {
    return GestureDetector(
      onTap: () => onProfileTap(index),
      child: Row(
        children: [
          getStudentProfilePic(listOfSessionDetailResponse[index]
              .studentDetail
              ?.profilePictureUrl),
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
                  Flexible(
                    child: AppText(
                      listOfSessionDetailResponse[index].studentDetail?.name ??
                          "",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
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
                listOfSessionDetailResponse[index].agenda ?? "",
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: AppText(
                      StringsUtils.getTagListTextFromListOfTags(
                          listOfSessionDetailResponse[index]
                                  .studentDetail
                                  ?.tags ??
                              [],
                          showTrimTagList: true),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
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

  onTapJoinNow(int index) {
    Navigator.of(context).pushNamed(AppRoutes.roomPageRoute,
        arguments: listOfSessionDetailResponse[index].teacherToken);
  }

  Widget getJoinNowCTA(int index) {
    return GestureDetector(
      onTap: () =>
          getLeftTimeInSeconds(listOfSessionDetailResponse[index].startDate!) <
                  1801
              ? onTapJoinNow(index)
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
