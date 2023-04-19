import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/session_bookin_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/student_session_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/view/review.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../resources/images.dart';
import '../bloc/student_session_bloc.dart';
import 'about.dart';
import 'availability.dart';

class StudentSessionScreen extends StatefulWidget {
  final StudentSessionArgument studentSessionArgument;

  const StudentSessionScreen({Key? key, required this.studentSessionArgument})
      : super(key: key);

  @override
  State<StudentSessionScreen> createState() => _StudentSessionScreenState();
}

class _StudentSessionScreenState extends State<StudentSessionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<StudentSessionBloc>(context).add(FetchTeacherDetailsEvent(
        teacherId: widget.studentSessionArgument.teacherId ?? ""));
  }

  TeacherDetails? teacherDetails;

  bool _isRebuildWidgetState(StudentSessionStates state) {
    var elm = state is StudentSessionInitialState ||
        state is UpdatedTabBarState ||
        state is FetchingTeacherDetailsState ||
        state is FetchingTeacherDetailsFailureState ||
        state is FetchedTeacherDetailsState;
    return elm;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSessionBloc, StudentSessionStates>(
      listener: (context, state) {
        if (state is FetchedTeacherDetailsState) {
          teacherDetails = state.teacherDetails;
        }
      },
      buildWhen: (previous, current) => _isRebuildWidgetState(current),
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: getScreeContent(),
        );
      },
    );
  }

  Widget getTopBanner() {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
          color: AppColors.lightCyan,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () => {Navigator.pop(context)},
                        child: const AppImage(image: ImageAsset.arrowBack)),
                    const AppImage(
                      image: ImageAsset.share,
                      height: 19,
                      width: 16,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: getMentorDetails(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getMentorsProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 92,
        width: 70,
        child: teacherDetails?.profilePictureUrl == null
            ? const AppImage(
                image: ImageAsset.blueAvatar,
              )
            : AppImage(
                image: teacherDetails?.profilePictureUrl ?? "",
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget getMentorDetails() {
    return Visibility(
      visible: teacherDetails != null,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1, color: AppColors.grey32)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getMentorsProfileImage(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        teacherDetails?.name ?? "",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.grey32,
                          borderRadius: BorderRadius.circular(11.0),
                        ),
                        width: 32,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.star,
                                size: 8,
                                color: Colors.amber,
                              ),
                              Text(
                                "5",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(
                    teacherDetails?.info ?? "",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  onTabTap(int index) {
    context.read<StudentSessionBloc>().add(UpdateTabBarEvent(index: index));
  }

  Widget categoryTab(String item) {
    int index =
        context.read<StudentSessionBloc>().sessionCategory.indexOf(item);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: InkWell(
          onTap: () => onTabTap(index),
          child: context.read<StudentSessionBloc>().selectedTabIndex == index
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

  Widget getScreeContent() {
    return Stack(
      children: [
        ListView(
          children: [
            Column(
              children: [
                getTopBanner(),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCategoryTab(),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (context.read<StudentSessionBloc>().selectedTabIndex ==
                          0)
                        AboutSession(
                          studentSessionArgument: widget.studentSessionArgument,
                        ),
                      if (context.read<StudentSessionBloc>().selectedTabIndex ==
                          1)
                        SessionAvailability(
                          studentSessionArgument: widget.studentSessionArgument,
                          teacherDetails: teacherDetails,
                        ),
                      if (context.read<StudentSessionBloc>().selectedTabIndex ==
                          2)
                        SessionReview()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppCta(
                onTap: () => onConfirmationTap(),
                color: context.read<StudentSessionBloc>().selectedTabIndex != 1
                    ? AppColors.cyanBlue
                    : context
                                .read<StudentSessionBloc>()
                                .selectedDateTimeModel !=
                            null
                        ? AppColors.cyanBlue
                        : AppColors.grey32,
                text: context.read<StudentSessionBloc>().selectedTabIndex == 1
                    ? AppStrings.confirm
                    : AppStrings.bookSession,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget getCategoryTab() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.grey32,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: context
            .read<StudentSessionBloc>()
            .sessionCategory
            .map((item) => categoryTab(item))
            .toList(),
      ),
    );
  }

  onConfirmationTap() {
    if (context.read<StudentSessionBloc>().selectedTabIndex != 1 &&
        context.read<StudentSessionBloc>().selectedDateTimeModel == null) {
      context.read<StudentSessionBloc>().add(UpdateTabBarEvent(index: 1));
    } else if (context.read<StudentSessionBloc>().selectedDateTimeModel !=
        null) {
      Navigator.of(context).pushNamed(AppRoutes.bookingConfirmation,
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
                      minutes: context.read<StudentSessionBloc>().sessionType ==
                              "short"
                          ? 15
                          : 30)),
              context.read<StudentSessionBloc>().sessionType ?? "",
              context.read<StudentSessionBloc>().amount ?? 0));
    }
  }
}
