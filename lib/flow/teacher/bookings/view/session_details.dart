import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/bookings/model/session_detail_arguments.dart';
import 'package:newversity/flow/teacher/bookings/view/bottom_sheets/profile_bottom_sheet.dart';
import 'package:newversity/flow/teacher/home/model/session_request_model.dart';
import 'package:newversity/flow/teacher/home/model/session_response_model.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/date_time_utils.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../bloc/session_details_bloc/booking_session_details_bloc.dart';
import 'bottom_sheets/cancel_bottom_sheet.dart';

class SessionDetailsScreen extends StatefulWidget {
  final SessionDetailArguments sessionDetailArguments;

  const SessionDetailsScreen({Key? key, required this.sessionDetailArguments})
      : super(key: key);

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  SessionDetailsResponse? sessionDetailsResponse;
  bool showError = false;
  bool isSendLoading = false;
  bool toReset = false;
  final _noteSenderController = TextEditingController();
  bool hasSent = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookingSessionDetailsBloc>(context)
        .add(FetchSessionDetailByIdEvent(id: widget.sessionDetailArguments.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<BookingSessionDetailsBloc,
              BookingSessionDetailsStates>(
            listener: (context, state) {
              if (state is FetchedSessionDetailByIdState) {
                sessionDetailsResponse = state.sessionDetails;
              }
              if (state is SavedSessionDetails) {
                isSendLoading = false;
                toReset = true;
                hasSent = true;
              }
            },
            builder: (context, state) {
              return sessionDetailsResponse != null
                  ? Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const AppImage(
                                          image: ImageAsset.arrowBack)),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      AppText(
                                        "Session Details",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      // Visibility(
                                      //   visible: !widget.isPrevious,
                                      //   child: GestureDetector(
                                      //     onTap: () => onTapCancel(),
                                      //     child: const AppText(
                                      //       "Cancel booking",
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w500,
                                      //       decoration: TextDecoration.underline,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  getDateTimeOfSession(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  getSessionStudentProfileView(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  getAgendaView(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  getFeedBackView(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  getRateContainer(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  getNoteForStudentLayout(),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          getJoinNowBeforeThreshHold(),
                          getJoinNowAfterThreshHold(),
                          getPaymentInitiated(),
                          getPaymentCompleted(),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  int getLeftTimeInSeconds(DateTime dateTime) {
    return (dateTime.difference(DateTime.now()).inSeconds);
  }

  Widget getScheduleLeftTime() {
    int timeLeftInSeconds =
        getLeftTimeInSeconds(sessionDetailsResponse!.startDate!);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideCountdown(
            duration: Duration(seconds: timeLeftInSeconds),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            slideDirection: SlideDirection.down,
            durationTitle: DurationTitle.id(),
            separator: ":",
            onChanged: (value) {
              if (value.inSeconds < 1801) {
                setState(() {});
              }
            },
            onDone: () {},
            textStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.cyanBlue),
            separatorStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget getPaymentCompleted() {
    return Visibility(
      visible: widget.sessionDetailArguments.isPrevious &&
          sessionDetailsResponse!.paymentId != null,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Container(
              width: 64,
              decoration: const BoxDecoration(
                  color: AppColors.cyanBlue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Center(
                child: AppText(
                  sessionDetailsResponse!.amount!.toString(),
                  fontSize: 16,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
                child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: AppColors.appYellow.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: const Center(
                child: AppText(
                  "Payment Credited to your account",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget getPaymentInitiated() {
    return Visibility(
      visible: widget.sessionDetailArguments.isPrevious &&
          sessionDetailsResponse!.paymentId == null,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Container(
              width: 64,
              decoration: const BoxDecoration(
                  color: AppColors.cyanBlue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Center(
                child: AppText(
                  sessionDetailsResponse!.amount!.toString(),
                  fontSize: 16,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
                child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: AppColors.perSessionRate.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: const Center(
                child: AppText(
                  "Payment initiated. Will be received with in 3-4 days",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget getNoteForStudentLayout() {
    return Visibility(
      visible: widget.sessionDetailArguments.isPrevious,
      child: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isSendLoading
                  ? const SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            color: AppColors.cyanBlue,
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () => !hasSent ? onSendNote() : null,
                      child: AppText(
                        hasSent ? "SENT!" : "SEND",
                        color: hasSent
                            ? AppColors.appYellow
                            : AppColors.strongGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              Visibility(
                visible: toReset,
                child: InkWell(
                  onTap: () => onResendNote(),
                  child: const AppText(
                    "RESET",
                    color: AppColors.strongGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  onResendNote() {
    _noteSenderController.text = "";
    toReset = false;
    hasSent = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  bool isFormIsValid() {
    return _noteSenderController.text.isNotEmpty;
  }

  onSendNote() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (isFormIsValid()) {
      isSendLoading = true;
      BlocProvider.of<BookingSessionDetailsBloc>(context).add(
          SessionAddingEvent(
              sessionSaveRequest: SessionSaveRequest(
                  id: sessionDetailsResponse!.id,
                  teacherId: sessionDetailsResponse!.teacherId,
                  studentId: sessionDetailsResponse!.studentId,
                  mentorNote: _noteSenderController.text)));
    } else {
      showError = true;
      setState(() {});
    }
  }

  Widget getFeedBackView() {
    return Visibility(
      visible: widget.sessionDetailArguments.isPrevious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            "Feedback by Student",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                "\"It was an awesome session\"",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              Container(
                width: 43,
                height: 23,
                decoration: BoxDecoration(
                  color: AppColors.grey32,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      AppImage(image: ImageAsset.star),
                      SizedBox(
                        width: 3,
                      ),
                      AppText(
                        "5",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          AppText(
            sessionDetailsResponse!.studentFeedback ??
                "This is Feedback Section",
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  onTapCancel() {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return AppAnimatedBottomSheet(
              bottomSheetWidget: BlocProvider<BookingSessionDetailsBloc>(
                  create: (context) => BookingSessionDetailsBloc(),
                  child: const CancelBooking()));
          // your stateful widget
        });
  }

  Widget getJoinNowAfterThreshHold() {
    return Visibility(
      visible: !widget.sessionDetailArguments.isPrevious &&
          getLeftTimeInSeconds(sessionDetailsResponse!.startDate!) < 1501,
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
          getLeftTimeInSeconds(sessionDetailsResponse!.startDate!) > 1501,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.creamColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                const AppText(
                  "Join Session",
                  fontSize: 16,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 5,
                ),
                getScheduleLeftTime()
              ],
            ),
          ),
        ),
      ),
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
                children: [
                  const AppText(
                    "Per Session",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  AppText(
                    sessionDetailsResponse!.sessionType! == "short"
                        ? "(15 min)"
                        : "(30 min)",
                    fontSize: 14,
                  ),
                ],
              ),
              AppText(
                sessionDetailsResponse!.amount.toString(),
                fontSize: 16,
                fontWeight: FontWeight.w700,
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
                sessionDetailsResponse!.agenda ?? "This is Agenda Section",
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
      text = DateTimeUtils.getBirthFormattedDateTime(
              sessionDetailsResponse!.endDate ?? DateTime.now()) +
          DateTimeUtils.getTimeInAMOrPM(
              sessionDetailsResponse!.endDate ?? DateTime.now());
    } else {
      text =
          "${DateTimeUtils.getBirthFormattedDateTime(sessionDetailsResponse!.startDate ?? DateTime.now())} ${DateTimeUtils.getTimeInAMOrPM(sessionDetailsResponse!.startDate ?? DateTime.now())} - ${DateTimeUtils.getTimeInAMOrPM(sessionDetailsResponse!.endDate ?? DateTime.now())}";
    }
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
            child:  ProfileBottomSheet(studentId: sessionDetailsResponse?.studentId ?? "",),
          )); // your stateful widget
        });
  }

  Widget getSessionStudentProfileView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey35,
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
                    sessionDetailsResponse!.studentId ?? "",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  AppText(
                    sessionDetailsResponse?.agenda ?? "JEE main",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AppText(
                    sessionDetailsResponse?.paymentId ??
                        "This is Qualification Section",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
