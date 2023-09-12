import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/common/mentor_personal_detail_card.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/session_bookin_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/student_session_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/view/review.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../resources/images.dart';
import '../bloc/student_session_bloc.dart';
import 'about.dart';
import 'availability.dart';
import 'content.dart';

class StudentSessionScreen extends StatefulWidget {
  final StudentSessionArgument studentSessionArgument;

  const StudentSessionScreen({Key? key, required this.studentSessionArgument})
      : super(key: key);

  @override
  State<StudentSessionScreen> createState() => _StudentSessionScreenState();
}

class _StudentSessionScreenState extends State<StudentSessionScreen> {
  TeacherDetailsModel? teacherDetails;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentSessionBloc>(context).add(FetchTeacherDetailsEvent(
        teacherId: widget.studentSessionArgument.teacherId ?? ""));
    if (widget.studentSessionArgument.pageIndex == 1) {
      context.read<StudentSessionBloc>().selectedTabIndex = 1;
    }
  }

  bool _isRebuildWidgetState(StudentSessionStates state) {
    return state is StudentSessionInitialState ||
        state is UpdatedTabBarState ||
        state is UpdateSelectedDateTimeIndexState ||
        state is FetchingTeacherDetailsState ||
        state is FetchingTeacherDetailsFailureState ||
        state is FetchedTeacherDetailsState;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSessionBloc, StudentSessionStates>(
      listener: (context, state) {
        if (state is FetchedTeacherDetailsState) {
          teacherDetails = state.teacherDetails;
        } else if (state is RequestSessionSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Request Sent to mentor",
              ),
            ),
          );
          Navigator.of(context).pop();
        } else if (state is RequestSessionFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message ?? "something went wrong",
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) => _isRebuildWidgetState(current),
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: getScreeContent(),
          ),
        );
      },
    );
  }

  Widget getTopBanner() {
    return Container(
      // height: 180,
      decoration: const BoxDecoration(
          color: AppColors.lightCyan,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: SafeArea(
        child: Padding(
          // padding: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => {Navigator.pop(context)},
                      child: const AppImage(image: ImageAsset.arrowBack)),
                  // const AppImage(
                  //   image: ImageAsset.share,
                  //   height: 19,
                  //   width: 16,
                  // ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              if (teacherDetails != null)
                ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    child:
                        MentorPersonalDetailCard(mentorDetail: teacherDetails!))
            ],
          ),
        ),
      ),
    );
  }

  Widget getMentorsProfileImage() {
    return SizedBox(
      // height: MediaQuery.of(context).size.height,
      width: 100,
      child: teacherDetails?.profilePictureUrl == null ||
              teacherDetails?.profilePictureUrl?.contains("https") == false
          ? const Center(
              child: AppImage(
                image: ImageAsset.blueAvatar,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                teacherDetails?.profilePictureUrl ?? "",
                fit: BoxFit.cover,
                height: 132,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Center(
                    child: AppImage(
                      image: ImageAsset.blueAvatar,
                    ),
                  );
                },
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
        Column(
          children: [
            getTopBanner(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getCategoryTab(),
                    if (context.read<StudentSessionBloc>().selectedTabIndex ==
                        0)
                      AboutSession(
                        studentSessionArgument: widget.studentSessionArgument,
                      ),
                    if (context.read<StudentSessionBloc>().selectedTabIndex ==
                        1)
                      BlocBuilder<StudentSessionBloc, StudentSessionStates>(
                        buildWhen: (previous, current) =>
                            current is UpdatedTabBarState,
                        builder: (context, state) {
                          return SessionAvailability(
                            studentSessionArgument:
                                widget.studentSessionArgument,
                            teacherDetails: teacherDetails,
                          );
                        },
                      ),
                    if (context.read<StudentSessionBloc>().selectedTabIndex ==
                        2)
                      const SharedContentRoute()
                  ],
                ),
              ),
            ),
          ],
        ),
        BlocBuilder<StudentSessionBloc, StudentSessionStates>(builder: (context, state) {
          return Column(
            children: [
              Expanded(child: Container()),
              Container(
                color: AppColors.whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppCta(
                    onTap: () => onConfirmationTap(),
                    isLoading: state is RequestSessionLoadingState,
                    color: _getCtaColor(),
                    text: _getCtaText(),
                  ),
                ),
              )
            ],
          );
        })
      ],
    );
  }

  Color _getCtaColor() {
    if (context.read<StudentSessionBloc>().selectedTabIndex == 1) {
      if (context.read<StudentSessionBloc>().noSlotsAvailable) {
        return AppColors.cyanBlue;
      } else {
        return context.read<StudentSessionBloc>().selectedDateTimeModel != null
            ? AppColors.cyanBlue
            : AppColors.grey32;
      }
    } else {
      return AppColors.cyanBlue;
    }
  }

  String _getCtaText() {
    if (context.read<StudentSessionBloc>().selectedTabIndex == 1) {
      if (context.read<StudentSessionBloc>().noSlotsAvailable) {
        return "Request Session";
      } else {
        return AppStrings.confirm;
      }
    } else {
      return AppStrings.bookSession;
    }
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
              context.read<StudentSessionBloc>().amount ?? 0,
              context.read<StudentSessionBloc>().availabilityId ?? ""));
    } else if (context.read<StudentSessionBloc>().noSlotsAvailable) {
      context.read<StudentSessionBloc>().add(RequestSessionEvent());
    }
  }
}
