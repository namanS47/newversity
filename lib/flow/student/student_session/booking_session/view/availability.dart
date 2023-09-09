import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/student_session/booking_session/bloc/student_session_bloc.dart';
import 'package:newversity/flow/teacher/availability/data/model/availability_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/date_time_utils.dart';
import '../../../../../themes/strings.dart';
import '../../../../teacher/availability/data/model/fetch_availability_request_model.dart';
import '../model/student_session_argument.dart';
import 'avaiblity_timing_widget.dart';

class SessionAvailability extends StatefulWidget {
  final StudentSessionArgument studentSessionArgument;
  final TeacherDetailsModel? teacherDetails;

  const SessionAvailability(
      {Key? key,
      required this.studentSessionArgument,
      required this.teacherDetails})
      : super(key: key);

  @override
  State<SessionAvailability> createState() => _SessionAvailabilityState();
}

class _SessionAvailabilityState extends State<SessionAvailability> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentSessionBloc>(context).add(
        FetchTeacherAvailabilityEvent(
            fetchAvailabilityRequestModel: FetchAvailabilityRequestModel(
                teacherId: widget.studentSessionArgument.teacherId
                )));
  }

  bool _isRebuildWidgetState(StudentSessionStates state) {
    var elm = state is FetchingTeacherAvailabilityState ||
        state is FetchedTeacherAvailabilityState ||
        state is FetchingTeacherAvailabilityFailureState ||
        state is NotTeacherSlotFoundState ||
        state is UpdatedAvailabilityIndexState;
    return elm;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSessionBloc, StudentSessionStates>(
        listener: (context, state) {},
        listenWhen: (previous, current) => _isRebuildWidgetState(current),
        buildWhen: (previous, current) => _isRebuildWidgetState(current),
        builder: (context, state) {
          if (state is FetchingTeacherAvailabilityState ||
              state is UpdatedTabBarState ||
              state is StudentSessionInitialState) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.cyanBlue,
                  ),
                ),
              ],
            );
          }
          if (state is FetchedTeacherAvailabilityState ||
              state is UpdatedAvailabilityIndexState) {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    getAvailableSlotHeader(),
                    const SizedBox(
                      height: 10,
                    ),
                    getAvailableSlotLayout(),
                    const SizedBox(
                      height: 20,
                    ),
                    AvailabilityTimingWidget(
                      teacherId: widget.studentSessionArgument.teacherId ?? "",
                      listOfSessionTimings:
                          context.read<StudentSessionBloc>().dateTimeMap[context
                                  .read<StudentSessionBloc>()
                                  .dateTimeMap
                                  .keys
                                  .elementAt(context
                                      .read<StudentSessionBloc>()
                                      .selectedDateIndex)] ??
                              [AvailabilityModel()],
                    )
                  ],
                ),
              ),
            );
          }
          if (state is NotTeacherSlotFoundState) {
            // return Container();
            return getAgendaContainer();
            // return const Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       height: 70,
            //     ),
            //     Center(
            //       child: AppImage(
            //         image: ImageAsset.paymentError,
            //       ),
            //     ),
            //     SizedBox(
            //       height: 25,
            //     ),
            //     Center(
            //       child: AppText(
            //         "No teacher slot available right now! \n please contact to admin",
            //         fontSize: 14,
            //         fontWeight: FontWeight.w400,
            //         color: AppColors.grey55,
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ],
            // );
          }
          if (state is FetchingTeacherAvailabilityFailureState) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                ),
                Center(
                  child: AppText("Something went wrong"),
                ),
              ],
            );
          } else {
            throw ArgumentError("unsupported state");
          }
        });
  }

  Widget getAgendaContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width,
      height: 156,
      decoration: BoxDecoration(
        color: AppColors.grey35,
        border: Border.all(width: 0.9, color: AppColors.grey32),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              "Agenda",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: AppTextFormField(
                hintText: "Specify your agenda here",
                keyboardType: TextInputType.text,
                onChange: (value) => {
                  context.read<StudentSessionBloc>().agenda = value
                },
                maxLines: 3,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getAvailableSlotLayout() {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: context.read<StudentSessionBloc>().dateTimeMap.length,
        itemBuilder: (context, index) => getSlotDataView(index),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 30),
      ),
    );
  }

  Widget getSlotDataView(int index) {
    return GestureDetector(
      onTap: () => context
          .read<StudentSessionBloc>()
          .add(UpdateDateIndexOfAvailabilityEvent(index: index)),
      child: Center(
        child: Container(
          height: 104,
          width: 104,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: context.read<StudentSessionBloc>().selectedDateIndex ==
                        index
                    ? AppColors.blackMerlin
                    : AppColors.grey32),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                        DateTimeUtils.getDayName(DateTimeUtils.getDateTime(
                            context
                                .read<StudentSessionBloc>()
                                .dateTimeMap
                                .keys
                                .elementAt(index))),
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                        "${(DateTimeUtils.getDateTime(context.read<StudentSessionBloc>().dateTimeMap.keys.elementAt(index))).day} ${DateTimeUtils.months[DateTimeUtils.getCurrentMonth(DateTimeUtils.getDateTime(context.read<StudentSessionBloc>().dateTimeMap.keys.elementAt(index))) - 1]}",
                        fontSize: 20,
                        fontWeight: FontWeight.w700)
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 104,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15.0)),
                    color: AppColors.strongGreen.withOpacity(0.12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Center(
                      child: AppText(
                          DateTimeUtils.getTotalDuration(
                              context.read<StudentSessionBloc>().dateTimeMap[
                                      context
                                          .read<StudentSessionBloc>()
                                          .dateTimeMap
                                          .keys
                                          .elementAt(index)] ??
                                  [AvailabilityModel()]),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.strongGreen),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getAvailableSlotHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppText(
          AppStrings.availableSlot,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        InkWell(
          onTap: () => {
            Navigator.of(context).pushNamed(AppRoutes.viewAllSlots,
                arguments: widget.studentSessionArgument)
          },
          child: const AppText(AppStrings.seeAll,
              fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
