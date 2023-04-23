import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/student_session/booking_session/bloc/student_session_bloc.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/date_availability_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/view/avaiblity_timing_widget.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/utils/date_time_utils.dart';

import '../../../../../common/common_utils.dart';
import '../../../../../common/common_widgets.dart';
import '../../../../../navigation/app_routes.dart';
import '../../../../../resources/images.dart';
import '../../../../../themes/colors.dart';
import '../../../../../themes/strings.dart';
import '../../../../teacher/availability/data/model/availability_model.dart';
import '../../../../teacher/availability/data/model/fetch_availability_request_model.dart';
import '../model/session_bookin_argument.dart';

class DateWiseSlotViewScreen extends StatefulWidget {
  final DateAvailabilityArgument dateAvailabilityArgument;

  const DateWiseSlotViewScreen(
      {Key? key, required this.dateAvailabilityArgument})
      : super(key: key);

  @override
  State<DateWiseSlotViewScreen> createState() => _DateWiseSlotViewScreenState();
}

class _DateWiseSlotViewScreenState extends State<DateWiseSlotViewScreen> {
  List<AvailabilityModel> listOfSessionTimings = [];
  TeacherDetailsModel? teacherDetails;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentSessionBloc>(context).add(
        FetchTeacherSessionTimingsEvent(
            fetchAvailabilityRequestModel: FetchAvailabilityRequestModel(
                teacherId: widget.dateAvailabilityArgument.teacherId,
                date: widget.dateAvailabilityArgument.currentDateTime)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSessionBloc, StudentSessionStates>(
      listener: (context, state) {
        if (state is FetchedTeacherSessionTimingsState) {
          listOfSessionTimings = state.availabilityList;
        }
      },
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
                    SingleChildScrollView(
                      primary: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getAppHeader(),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height,
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
                                  teacherId: widget
                                          .dateAvailabilityArgument.teacherId ??
                                      "",
                                  listOfSessionTimings: listOfSessionTimings,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget getConfirmationCTA() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppCta(
        color: context.read<StudentSessionBloc>().selectedDateTimeModel != null
            ? AppColors.cyanBlue
            : AppColors.grey32,
        onTap: () =>
            context.read<StudentSessionBloc>().selectedDateTimeModel != null
                ? onConfirmTap()
                : null,
        text: AppStrings.confirm,
      ),
    );
  }

  onConfirmTap() {
    Navigator.of(context).pushNamed(AppRoutes.bookingConfirmation,
        arguments: SessionBookingArgument(
          CommonUtils().getLoggedInUser(),
          widget.dateAvailabilityArgument.teacherId ?? "",
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
            context.read<StudentSessionBloc>().availabilityId ?? ""
        ));
  }

  Widget getAppHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          InkWell(
              onTap: () => {Navigator.pop(context)},
              child: AppImage(image: ImageAsset.arrowBack)),
          const SizedBox(
            width: 10,
          ),
          AppText(
            DateTimeUtils.getBirthFormattedDateTime(
                widget.dateAvailabilityArgument.currentDateTime),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          )
        ],
      ),
    );
  }
}
