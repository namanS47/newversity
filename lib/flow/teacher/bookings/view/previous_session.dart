import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/bookings/bloc/previous_section_bloc/previous_session_bloc.dart';
import 'package:newversity/flow/teacher/bookings/model/previous_session_data.dart';
import 'package:newversity/flow/teacher/bookings/view/bottom_sheets/sort_by_bottom_sheet_previous_session.dart';

import '../../../../common/common_widgets.dart';
import '../../../../navigation/app_routes.dart';
import '../../../../resources/images.dart';
import '../../../../themes/colors.dart';

class PreviousSessions extends StatefulWidget {
  const PreviousSessions({Key? key}) : super(key: key);

  @override
  State<PreviousSessions> createState() => _PreviousSessionsState();
}

class _PreviousSessionsState extends State<PreviousSessions> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreviousSessionBloc, PreviousSessionStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            getTimeFilter(),
            const SizedBox(
              height: 10,
            ),
            getListOfPreviousSessions(),
          ],
        );
      },
    );
  }

  List<PreviousSessionData> listOfPreviousData =
      PreviousSessionData.listOfPreviousData;

  Widget getListOfPreviousSessions() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        listOfPreviousData.length,
        (curIndex) {
          return getPreviousSessionDataView(curIndex);
        },
      ),
    );
  }

  onProfileTap() {
    Navigator.of(context).pushNamed(AppRoutes.sessionDetails, arguments: true);
  }

  Widget getPreviousSessionDataView(int index) {
    return GestureDetector(
      onTap: () => onProfileTap(),
      child: Row(
        children: [
          const SizedBox(
            height: 66,
            width: 66,
            child: CircleAvatar(
              radius: 200,
              child: AppImage(
                image: ImageAsset.blueAvatar,
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
              AppText(
                listOfPreviousData[index].name,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    listOfPreviousData[index].guidanceFor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  AppText(
                    "${listOfPreviousData[index].totalDuration} min call",
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    listOfPreviousData[index].qualification,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  AppText(
                    "On: ${listOfPreviousData[index].date}",
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
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

  Widget getTimeFilter() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: context.read<PreviousSessionBloc>().timeFilter.length + 2,
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
    BlocProvider.of<PreviousSessionBloc>(context)
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
                context.read<PreviousSessionBloc>().selectedTimeFilterIndex ==
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
                context.read<PreviousSessionBloc>().timeFilter[index],
                fontSize: 14,
                color: context
                            .read<PreviousSessionBloc>()
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

  onTapAllTimeChip() {
    BlocProvider.of<PreviousSessionBloc>(context)
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
                context.read<PreviousSessionBloc>().selectedTimeFilterIndex ==
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
                            .read<PreviousSessionBloc>()
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
              bottomSheetWidget: BlocProvider<PreviousSessionBloc>(
                  create: (context) => PreviousSessionBloc(),
                  child: const SortByForPreviousSessionBottomSheet()));
          // your stateful widget
        });
  }

  Widget getBottomNabWidget() {
    return SizedBox(
      height: 82,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(child: getResetButton()),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: getApplyWidget()),
            ],
          ),
        ),
      ),
    );
  }

  onApplyTap() {}

  Widget getApplyWidget() {
    return GestureDetector(
      onTap: () => onApplyTap(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.cyanBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: AppText(
              "Apply",
              color: AppColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  onResetTap() {
    BlocProvider.of<PreviousSessionBloc>(context)
        .add(OnChangeSortByIndexEvent(index: 0));
  }

  Widget getResetButton() {
    return InkWell(
      onTap: () => onResetTap(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.cyanBlue,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: AppText(
              "Reset",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
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
}
