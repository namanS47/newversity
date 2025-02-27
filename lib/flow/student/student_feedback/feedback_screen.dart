import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/student_session/my_session/model/session_detail_response_model.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';

import '../../../utils/date_time_utils.dart';
import '../../teacher/home/model/session_request_model.dart';
import 'bloc/student_feedback_bloc.dart';

class StudentFeedBackScreen extends StatefulWidget {
  final SessionDetailResponseModel sessionDetails;

  const StudentFeedBackScreen({Key? key, required this.sessionDetails})
      : super(key: key);

  @override
  State<StudentFeedBackScreen> createState() => _StudentFeedBackScreenState();
}

class _StudentFeedBackScreenState extends State<StudentFeedBackScreen> {
  bool showError = false;
  bool isLoading = false;
  final _studentReviewController = TextEditingController();

  @override
  void initState() {
    _studentReviewController.text = widget.sessionDetails.studentFeedback ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _studentReviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Row(
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
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  const Center(
                    child: AppImage(
                      image: ImageAsset.icGrowth,
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Center(
                    child: AppText(
                      "Congratulation you have successfully completed a session with ${widget.sessionDetails.studentDetail?.name ?? ""}",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  getMentorDetails(),
                  const SizedBox(
                    height: 24,
                  ),
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
                    height: 50,
                  ),
                  getRateYourExperienceContainer(),
                  const SizedBox(
                    height: 22,
                  ),
                  getReviewEditLayout(),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
        getBottomView(),
      ],
    );
  }

  Widget getReviewEditLayout() {
    return AppTextFormField(
      maxLines: 5,
      hintText: "Give a review",
      controller: _studentReviewController,
    );
  }

  Widget getBottomView() {
    return Container(
      height: 82,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: Colors.grey, //New
              blurRadius: 5.0,
              offset: Offset(0, -2))
        ],
      ),
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

  bool isFormValid() {
    return _studentReviewController.text.isNotEmpty;
  }

  onSubmitTap() {
    if (isFormValid()) {
      isLoading = true;
      BlocProvider.of<StudentFeedbackBloc>(context).add(
          SaveStudentFeedbackEvent(
              forRating: false,
              sessionSaveRequest: SessionSaveRequest(
                  id: widget.sessionDetails.id,
                  teacherId: widget.sessionDetails.teacherId,
                  studentId: widget.sessionDetails.studentId,
                  studentFeedback: _studentReviewController.text)));
    } else {
      isLoading = false;
      showError = true;
      setState(() {});
    }
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

  Widget getRateYourExperienceContainer() {
    return Visibility(
      visible: isPrevious,
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
        ],
      ),
    );
  }

  _saveRating(double updatedRate) {
    BlocProvider.of<StudentFeedbackBloc>(context).add(SaveStudentFeedbackEvent(
        forRating: true,
        sessionSaveRequest: SessionSaveRequest(
            id: widget.sessionDetails.id,
            teacherId: widget.sessionDetails.teacherId,
            studentId: widget.sessionDetails.studentId,
            studentRating: updatedRate)));
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
        initialRating: widget.sessionDetails.studentRating ?? 0,
        itemSize: 25,
        updateOnDrag: true,
        glow: true,
        itemPadding: const EdgeInsets.symmetric(horizontal: 3),
        onRatingUpdate: (value) => _saveRating(value));
  }

  Widget getDateTimeOfSession() {
    String timeText = getTimeText();
    String durationText = widget.sessionDetails.sessionType == "long" ? "30 min" : "15 min";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          timeText,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        AppText(
          "Duration : $durationText",
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  bool isPrevious = true;

  String getTimeText() {
    String text = "";
    if (isPrevious) {
      text =
          "${DateTimeUtils.getBirthFormattedDateTime(widget.sessionDetails.startDate ?? DateTime.now())} ${DateTimeUtils.getTimeInAMOrPM(widget.sessionDetails.endDate ?? DateTime.now())}";
    } else {
      text =
          "${DateTimeUtils.getBirthFormattedDateTime(widget.sessionDetails.startDate ?? DateTime.now())} ${DateTimeUtils.getTimeInAMOrPM(widget.sessionDetails.startDate ?? DateTime.now())} - ${DateTimeUtils.getTimeInAMOrPM(widget.sessionDetails.endDate ?? DateTime.now())}";
    }
    return text;
  }

  onMentorDetailsTap() {}

  Widget getMentorsProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 92,
        width: 70,
        child: widget.sessionDetails.teacherDetail?.profilePictureUrl == null
            ? const AppImage(
                image: ImageAsset.blueAvatar,
              )
            : Image.network(
                widget.sessionDetails.teacherDetail?.profilePictureUrl ?? "",
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: AppImage(
                        image: ImageAsset.blueAvatar,
                      ),
                    ),
                  );
                },
                fit: BoxFit.fill,
              ),
      ),
    );
  }

  Widget getMentorDetails() {
    return GestureDetector(
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        widget.sessionDetails.teacherDetail?.name ?? "",
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
                            children: [
                              const Icon(
                                Icons.star,
                                size: 8,
                                color: Colors.amber,
                              ),
                              AppText(
                                "${widget.sessionDetails.studentRating}",
                                fontSize: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  AppText(
                    "${widget.sessionDetails.teacherDetail?.education ?? ""}, ${widget.sessionDetails.teacherDetail?.title ?? ""}",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  AppText(
                    widget.sessionDetails.teacherDetail?.info ??
                        AppStrings.loremText,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
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
}
