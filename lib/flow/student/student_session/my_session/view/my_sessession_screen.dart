import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/student_session/my_session/bloc/my_session_bloc.dart';
import 'package:newversity/flow/student/student_session/previous_session/bloc/student_previous_session_bloc.dart';
import 'package:newversity/flow/student/student_session/previous_session/view/student_previous_session.dart';
import 'package:newversity/flow/student/student_session/upcoming_session/bloc/student_upcoming_session_bloc.dart';
import 'package:newversity/flow/student/student_session/upcoming_session/view/student_upcoming_session.dart';

import '../../../../../themes/colors.dart';
import '../../../../../themes/strings.dart';

class MySessionScreen extends StatefulWidget {
  const MySessionScreen({Key? key}) : super(key: key);

  @override
  State<MySessionScreen> createState() => _MySessionScreenState();
}

class _MySessionScreenState extends State<MySessionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MySessionBloc, MySessionStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Stack(
          children: [
            getTopBanner(),
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: AppText(
                      AppStrings.mySessions,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            getCategoryTab(),
                            context.read<MySessionBloc>().selectedIndex == 0
                                ? BlocProvider<StudentUpcomingSessionBloc>(
                                    create: (context) =>
                                        StudentUpcomingSessionBloc(),
                                    child: const Expanded(
                                        child:
                                            StudentUpcomingSessionScreen()))
                                : BlocProvider<StudentPreviousSessionBloc>(
                                    create: (context) =>
                                        StudentPreviousSessionBloc(),
                                    child: Expanded(
                                        child:
                                            const StudentPreviousSessionScreen())),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  onTabTap(int index) {
    context.read<MySessionBloc>().add(ChangeMySessionTabEvent(index: index));
  }

  Widget categoryTab(String item) {
    int index = context.read<MySessionBloc>().mySessionCat.indexOf(item);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: InkWell(
          onTap: () {
            onTabTap(index);
          },
          child: context.read<MySessionBloc>().selectedIndex == index
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
              .read<MySessionBloc>()
              .mySessionCat
              .map((item) => categoryTab(item))
              .toList(),
        ),
      ),
    );
  }

  Widget getTopBanner() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
          color: AppColors.lightCyan,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
    );
  }
}
