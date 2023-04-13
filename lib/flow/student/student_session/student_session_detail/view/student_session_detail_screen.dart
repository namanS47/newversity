import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:newversity/flow/student/student_session/student_session_detail/bloc/student_session_detail_bloc.dart';
import 'package:newversity/flow/student/student_session/student_session_detail/view/bottom_sheet/review_sheet.dart';
import 'package:newversity/flow/teacher/bookings/model/session_detail_arguments.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../resources/images.dart';
import '../../../../../themes/colors.dart';
import '../../../../../themes/strings.dart';
import '../../../../../utils/date_time_utils.dart';

class StudentSessionDetailScreen extends StatefulWidget {
  final SessionDetailArguments sessionDetailArguments;

  const StudentSessionDetailScreen(
      {Key? key, required this.sessionDetailArguments})
      : super(key: key);

  @override
  State<StudentSessionDetailScreen> createState() =>
      _StudentSessionDetailScreenState();
}

class _StudentSessionDetailScreenState
    extends State<StudentSessionDetailScreen> {
  bool showError = false;
  bool isSendLoading = false;
  bool toReset = false;
  final _noteSenderController = TextEditingController();
  bool hasSent = false;

  @override
  void initState() {
    super.initState();
  }

  onMentorDetailsTap() {
    Navigator.of(context).pushNamed(AppRoutes.bookSession);
  }

  Widget getMentorDetails() {
    return GestureDetector(
      onTap: () => onMentorDetailsTap(),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: const SizedBox(
                width: 70,
                height: 92,
                child: AppImage(
                  image: ImageAsset.mentor,
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                      const AppText(
                        "Akshat Kamesra",
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
                  const AppText(
                    AppStrings.loremText,
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

  Widget getRaiseAnIssueWidget() {
    return Visibility(
      visible: widget.sessionDetailArguments.isPrevious,
      child: GestureDetector(
        onTap: () =>
            {Navigator.of(context).pushNamed(AppRoutes.raiseIssueRoute)},
        child: const AppText(
          "Raise an issue",
          decoration: TextDecoration.underline,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child:
                                  const AppImage(image: ImageAsset.arrowBack)),
                          getRaiseAnIssueWidget()
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          AppText(
                            "Session Details",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getDateTimeOfSession(),
                      const SizedBox(
                        height: 20,
                      ),
                      getMentorDetails(),
                      const SizedBox(
                        height: 20,
                      ),
                      getAgendaView(),
                      const SizedBox(
                        height: 10,
                      ),
                      getNoteByMentor(),
                      const SizedBox(
                        height: 10,
                      ),
                      getRateYourExperienceContainer(),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            getBottomView(),
          ],
        ),
      ),
    );
  }

  Widget getRatingBar() {
    return RatingBar(
        ratingWidget: RatingWidget(
            full: const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            empty: const Icon(
              Icons.star,
              color: AppColors.grey32,
            ),
            half: Container()),
        minRating: 1,
        maxRating: 5,
        initialRating: 0,
        itemSize: 25,
        updateOnDrag: true,
        glow: true,
        itemPadding: const EdgeInsets.symmetric(horizontal: 3),
        onRatingUpdate: (value) => _saveRating(value));
  }

  _saveRating(double updatedRate) {}

  Widget getRateYourExperienceContainer() {
    return Visibility(
      visible: widget.sessionDetailArguments.isPrevious,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppImage(image: ImageAsset.thumbsUp),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                "Rate your experience",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 10,
              ),
              getRatingBar(),
            ],
          )),
          getReviewContainer(),
        ],
      ),
    );
  }

  onReviewTap() async {
    await showModalBottomSheet<dynamic>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        isScrollControlled: true,
        builder: (_) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: AppAnimatedBottomSheet(
                bottomSheetWidget: BlocProvider<StudentSessionDetailBloc>(
                    create: (context) => StudentSessionDetailBloc(),
                    child: const StudentReviewSheet())),
          );
          // your stateful widget
        }).whenComplete(() {
      // BlocProvider.of<ProfileBloc>(context).add(FetchTeacherDetailsEvent());
    });
  }

  Widget getReviewContainer() {
    return GestureDetector(
      onTap: () => onReviewTap(),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(width: 1, color: AppColors.cyanBlue),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
          child: AppText(
            "Give a review",
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget getBottomView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          AppImage(
            width: MediaQuery.of(context).size.width,
            image: ImageAsset.detailDesign,
            fit: BoxFit.cover,
          ),
          Positioned(
              left: 16,
              bottom: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        "Order summary",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          AppText(
                            "Per session",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey55,
                          ),
                          AppText(
                            "₹150",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackMerlin,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: AppColors.grey35,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          AppText(
                            "Total amount paid",
                            color: AppColors.cyanBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          AppText(
                            "₹150",
                            color: AppColors.cyanBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const AppText(
                        "Payment method : UPI",
                        color: AppColors.cyanBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      getJoinNowBeforeThreshHold(),
                      getJoinNowAfterThreshHold(),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget getDateTimeOfSession() {
    String timeText = getTimeText();
    return AppText(
      timeText,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  String getTimeText() {
    String text = "";
    if (widget.sessionDetailArguments.isPrevious) {
      text = DateTimeUtils.getBirthFormattedDateTime(DateTime.now()) +
          DateTimeUtils.getTimeInAMOrPM(DateTime.now());
    } else {
      text =
          "${DateTimeUtils.getBirthFormattedDateTime(DateTime.now())} ${DateTimeUtils.getTimeInAMOrPM(DateTime.now())} - ${DateTimeUtils.getTimeInAMOrPM(DateTime.now())}";
    }
    return text;
  }

  int getLeftTimeInSeconds(DateTime dateTime) {
    return (dateTime.difference(DateTime.now()).inSeconds);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Widget getNoteByMentor() {
    return Visibility(
      visible: widget.sessionDetailArguments.isPrevious,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppColors.grey35,
            border: Border.all(width: 0.9, color: AppColors.grey32),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppText(
                "Note by mentor",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: 10,
              ),
              AppText(
                "\"It was an awesome session\"",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: 10,
              ),
              AppText(
                AppStrings.loremText,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getJoinNowAfterThreshHold() {
    return Visibility(
      visible: !widget.sessionDetailArguments.isPrevious &&
          getLeftTimeInSeconds(DateTime(2024)) < 1801,
      child: AppCta(
        onTap: () => joinRoom(),
        text: "Join now",
        isLoading: false,
      ),
    );
  }

  joinRoom() {}

  Widget getStartingTime(int hour, int min, int sec) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          hour.toString(),
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        const AppText(
          "H",
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.strongGreen,
        ),
        AppText(
          ":$min",
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        const AppText(
          "M",
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.strongGreen,
        ),
        AppText(
          ":$sec",
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        const AppText(
          "S",
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.strongGreen,
        ),
      ],
    );
  }

  Widget getJoinNowBeforeThreshHold() {
    return Visibility(
      visible: !widget.sessionDetailArguments.isPrevious &&
          getLeftTimeInSeconds(DateTime(2024)) > 1801,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.creamColor,
          border: Border.all(width: 1, color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            children: [
              const AppText(
                "Start at",
                fontSize: 16,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 5,
              ),
              getScheduleLeftTime(),
            ],
          ),
        ),
      ),
    );
  }

  bool isTimeUp = false;

  Widget getScheduleLeftTime() {
    int timeLeftInSeconds = getLeftTimeInSeconds(DateTime(2024));
    return SlideCountdown(
      duration: Duration(seconds: timeLeftInSeconds),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      slideDirection: SlideDirection.down,
      durationTitle: DurationTitle.id(),
      separator: ":",
      onDone: () {
        isTimeUp = true;
      },
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      separatorStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    );
  }

  Widget getRateContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.perSessionRate,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  AppText(
                    "Per Session",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAgendaView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.sessionDetailArguments.isPrevious ? 98 : 156,
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
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: AppText(
                "This is Agenda Section",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
