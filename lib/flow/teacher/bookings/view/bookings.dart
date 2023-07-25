import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/bookings/bloc/previous_section_bloc/previous_session_bloc.dart';
import 'package:newversity/flow/teacher/bookings/bloc/teacher_bookings_bloc.dart';
import 'package:newversity/flow/teacher/bookings/bloc/upcoming_session_bloc/upcoming_session_bloc.dart';
import 'package:newversity/flow/teacher/bookings/view/previous_session.dart';
import 'package:newversity/flow/teacher/bookings/view/upcoming_sessions.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';

import '../../../../utils/event_broadcast.dart';

class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

Widget getTopBanner() {
  return Container(
    height: 200,
    decoration: const BoxDecoration(
        color: AppColors.lightCyan,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
  );
}

class _BookingsState extends State<Bookings> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherBookingsBloc, TeacherBookingStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            EventsBroadcast.get().send(ChangeHomePageIndexEvent(index: 0));
            return Future.value(false);
          },
          child: Stack(
            children: [
              getTopBanner(),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: AppText(
                        AppStrings.myBookings,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              getCategoryTab(),
                              context.read<TeacherBookingsBloc>().selectedIndex ==
                                      0
                                  ? BlocProvider<UpcomingSessionBloc>(
                                      create: (context) => UpcomingSessionBloc(),
                                      child: const Expanded(
                                          child: UpcomingSessions()))
                                  : BlocProvider<PreviousSessionBloc>(
                                      create: (context) => PreviousSessionBloc(),
                                      child: const Expanded(
                                          child: PreviousSessions())),
                            ],
                          ),
                        ),
                      ),
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

  Widget categoryTab(String item) {
    int index =
        context.read<TeacherBookingsBloc>().sessionCategory.indexOf(item);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: InkWell(
          onTap: () {
            onTabTap(index);
          },
          child: context.read<TeacherBookingsBloc>().selectedIndex == index
              ? Container(
                  height: 38,
                  decoration: BoxDecoration(
                      color: AppColors.cyanBlue,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Center(
                    child: Text(
                      item,
                      style: const TextStyle(color: AppColors.whiteColor),
                    ),
                  ),
                )
              : SizedBox(
                  height: 38,
                  child: Center(
                    child: Text(
                      item,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  onTabTap(int index) {
    context
        .read<TeacherBookingsBloc>()
        .add(ChangeSessionTabEvent(index: index));
  }

  Widget getCategoryTab() {
    return Container(
      height: 44,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.grey32,
        borderRadius: BorderRadius.circular(38.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey32.withOpacity(0.15),
            blurRadius: 4.0,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0, top: 5.0, bottom: 5.0),
        child: Row(
          children: context
              .read<TeacherBookingsBloc>()
              .sessionCategory
              .map((item) => categoryTab(item))
              .toList(),
        ),
      ),
    );
  }

  isRebuildWidgetState(TeacherBookingStates current) {
    return current is UpdatedSessionState;
  }
}
