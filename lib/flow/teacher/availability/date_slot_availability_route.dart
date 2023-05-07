import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/availability/availability_bloc/availability_bloc.dart';
import 'package:newversity/resources/images.dart';

import '../../../common/common_widgets.dart';
import '../../../navigation/app_routes.dart';
import '../../../themes/colors.dart';
import '../../../utils/date_time_utils.dart';
import 'data/model/availability_model.dart';

class DateWiseAvailabilityRoute extends StatefulWidget {
  const DateWiseAvailabilityRoute({Key? key}) : super(key: key);

  @override
  State<DateWiseAvailabilityRoute> createState() =>
      _DateWiseAvailabilityRouteState();
}

class _DateWiseAvailabilityRouteState extends State<DateWiseAvailabilityRoute> {
  Map<String, List<AvailabilityModel>> lisOfAvailability = {};

  @override
  void initState() {
    super.initState();
    context.read<AvailabilityBloc>().add(FetchTeacherAvailabilityDateEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightCyan,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
              ),
              child: BlocConsumer<AvailabilityBloc, AvailabilityState>(
                listener: (context, state) {
                  if (state is FetchedTeacherAvailabilityDateState) {
                    lisOfAvailability =
                        context.read<AvailabilityBloc>().dateTimeMap;
                  }
                },
                builder: (context, state) {
                  if (state is FetchingTeacherAvailabilityDateState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }
                  if (state is NotFoundTeacherAvailabilityDateState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: const [
                            AppImage(image: ImageAsset.nothingFoundIcon),
                            SizedBox(
                              height: 20,
                            ),
                            AppText(
                              "No Slots Available",
                              color: AppColors.appYellow,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is FetchedTeacherAvailabilityDateState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getUpcomingContainers(),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    );
                  }

                  return const AppText("Something Went Wrong");
                },
              ),
            )),
      ),
    );
  }

  Widget getUpcomingContainers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: getUpcomingDateList(),
        )
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

  onSlotDateTap(int index) {
    context.read<AvailabilityBloc>().add(UpdateAvailabilityPageEvent(
        selectedDate: DateTimeUtils.getDateTime(
            lisOfAvailability.keys.elementAt(index))));
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
                  color: AppColors.whiteColor.withOpacity(0.35),
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
              Expanded(child: Container()),
              Container(
                width: 93,
                decoration: BoxDecoration(
                  color: AppColors.lightCyan.withOpacity(0.35),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColors.grey55, width: 1),
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.whiteColor),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0, vertical: 3),
                              child: AppText(
                                "${DateTimeUtils.getTotalDurationInDeci(lisOfAvailability[context.read<AvailabilityBloc>().dateTimeMap.keys.elementAt(index)] ?? [
                                      AvailabilityModel()
                                    ])} ",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const AppText(
                          "Available",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
