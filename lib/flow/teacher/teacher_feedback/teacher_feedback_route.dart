import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newversity/resources/images.dart';

import '../../../common/common_widgets.dart';
import '../../../navigation/app_routes.dart';
import '../../../themes/colors.dart';
import '../../../utils/date_time_utils.dart';
import '../../student/student_feedback/bloc/student_feedback_bloc.dart';
import '../../student/student_session/my_session/model/session_detail_response_model.dart';
import '../bookings/bloc/session_details_bloc/booking_session_details_bloc.dart';
import '../bookings/view/bottom_sheets/profile_bottom_sheet.dart';
import '../home/model/session_request_model.dart';

class TeacherFeedbackRoute extends StatefulWidget {
  final SessionDetailResponseModel sessionDetails;

  const TeacherFeedbackRoute({Key? key, required this.sessionDetails})
      : super(key: key);

  @override
  State<TeacherFeedbackRoute> createState() => _TeacherFeedbackRouteState();
}

class _TeacherFeedbackRouteState extends State<TeacherFeedbackRoute> {
  final _noteSenderController = TextEditingController();
  bool isLoading = false;
  bool toReset = false;
  bool showError = false;
  bool hasSent = false;

  @override
  void initState() {
    _noteSenderController.text = widget.sessionDetails.mentorNote ?? "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _noteSenderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocConsumer<StudentFeedbackBloc, StudentFeedbackState>(
          listener: (context, state) {
            if (state is SaveStudentFeedbackSuccessState && state.shouldPopScreen) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return _getScreenContent();
          },
        ),
      ),
    );
  }

  Widget _getScreenContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topIconWidget(),
            Center(child: SvgPicture.asset(ImageAsset.successIcon)),
            const Center(
              child: Text(
                "Congratulation",
                style: TextStyle(
                    color: AppColors.strongCyan, fontWeight: FontWeight.bold),
              ),
            ),
            const Center(
              child: Text(
                "you have impacted life of one more student",
                style: TextStyle(
                  color: AppColors.strongCyan,
                ),
              ),
            ),
            getSessionStudentProfileView(),
            const AppText(
              "Session Details",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 10,
            ),
            getDateTimeOfSession(),
            const SizedBox(
              height: 10,
            ),
            getNoteForStudentLayout(),
            getBottomView(),
          ],
        ),
      ),
    );
  }

  Widget topIconWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const AppImage(
            image: ImageAsset.share,
            color: AppColors.blackMerlin,
            height: 25,
            width: 25,
          ),
          const SizedBox(
            width: 35,
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const AppImage(
              image: ImageAsset.close,
              color: AppColors.blackMerlin,
              height: 25,
              width: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget getSessionStudentProfileView() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        // color: AppColors.grey35,
        border: Border.all(width: 0.9, color: AppColors.grey32),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onProfileTap(),
                child: const SizedBox(
                  height: 66,
                  width: 66,
                  child: CircleAvatar(
                    radius: 200,
                    child: AppImage(
                      image: ImageAsset.blueAvatar,
                    ),
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
                      widget.sessionDetails.studentDetail?.name ?? "",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    AppText(
                      widget.sessionDetails.agenda ?? "",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getDateTimeOfSession() {
    String timeText = getTimeText();
    String durationText =
        widget.sessionDetails.sessionType == "long" ? "30 min" : "15 min";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          timeText,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        AppText(
          "Duration : $durationText",
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget getNoteForStudentLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Note for Student",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        AppTextFormField(
          controller: _noteSenderController,
          maxLines: 5,
          hintText: "Give a note",
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget getBottomView() {
    return SizedBox(
      height: 82,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(child: getHelpCTA()),
            const SizedBox(
              width: 20,
            ),
            Expanded(child: getSubmitReviewCTA())
          ],
        ),
      ),
    );
  }

  Widget getHelpCTA() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.helpAndSupport);
      },
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.cyanBlue)),
        child: const Center(
            child: AppText(
          "Get Help",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        )),
      ),
    );
  }

  Widget getSubmitReviewCTA() {
    return GestureDetector(
      onTap: () => onSubmitTap(),
      child: Container(
        height: 50,
        width: 162,
        decoration: BoxDecoration(
            color: AppColors.cyanBlue,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.cyanBlue)),
        child: Center(
            child: isLoading
                ? CommonWidgets.getCircularProgressIndicator()
                : const AppText(
                    "Submit",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  )),
      ),
    );
  }

  String getTimeText() {
    String text = "";
    text =
        "${DateTimeUtils.getBirthFormattedDateTime(widget.sessionDetails.startDate ?? DateTime.now())} ${DateTimeUtils.getTimeInAMOrPM(widget.sessionDetails.startDate ?? DateTime.now())} - ${DateTimeUtils.getTimeInAMOrPM(widget.sessionDetails.endDate ?? DateTime.now())}";
    return text;
  }

  onProfileTap() {
    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (_) {
        return AppAnimatedBottomSheet(
          bottomSheetWidget: BlocProvider<BookingSessionDetailsBloc>(
            create: (context) => BookingSessionDetailsBloc(),
            child: ProfileBottomSheet(
              studentId: widget.sessionDetails.studentId ?? "",
            ),
          ),
        ); // your stateful widget
      },
    );
  }

  onSubmitTap() {
    if (_noteSenderController.text.isNotEmpty) {
      isLoading = true;
      BlocProvider.of<StudentFeedbackBloc>(context).add(
          SaveStudentFeedbackEvent(
              forRating: false,
              sessionSaveRequest: SessionSaveRequest(
                  id: widget.sessionDetails.id,
                  teacherId: widget.sessionDetails.teacherId,
                  studentId: widget.sessionDetails.studentId,
                  mentorNote: _noteSenderController.text)));
    } else {
      isLoading = false;
      showError = true;
      setState(() {});
    }
  }
}
