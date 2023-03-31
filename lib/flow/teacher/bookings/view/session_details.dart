import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/bookings/view/bottom_sheets/profile_bottom_sheet.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

import '../bloc/session_details_bloc/session_details_bloc.dart';
import 'bottom_sheets/cancel_bottom_sheet.dart';

class SessionDetails extends StatefulWidget {
  final bool isPrevious;
  const SessionDetails({Key? key, required this.isPrevious}) : super(key: key);

  @override
  State<SessionDetails> createState() => _SessionDetailsState();
}

class _SessionDetailsState extends State<SessionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const AppImage(image: ImageAsset.arrowBack)),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(
                          "Session Details",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        Visibility(
                          visible: !widget.isPrevious,
                          child: GestureDetector(
                            onTap: () => onTapCancel(),
                            child: const AppText(
                              "Cancel booking",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
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
                  ],
                ),
              ),
              getJoinNowBeforeThreshHold(),
              getJoinNowAfterThreshHold(),
              getPaymentInitiated(),
              getPaymentCompleted(),
            ],
          ),
        ),
      ),
    );
  }

  bool isPaymentCompleted = true;

  Widget getPaymentCompleted() {
    return Visibility(
      visible: widget.isPrevious && isPaymentCompleted,
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
              child: const Center(
                child: AppText(
                  "₹300",
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
      visible: widget.isPrevious && !isPaymentCompleted,
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
              child: const Center(
                child: AppText(
                  "₹300",
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
      visible: widget.isPrevious,
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
          const AppTextFormField(
            maxLines: 5,
            hintText: "Give a note",
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AppText(
                "SEND",
                color: AppColors.strongGreen,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              AppText(
                "00/3000",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getFeedBackView() {
    return Visibility(
      visible: widget.isPrevious,
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
          const AppText(
            "Språkplikt repobel. Plar antivävis. Eurolere plakavis. Reasa ling ör. Toktiga. Mobil-tv talibanisering. Antengar. Karade. Re asyl. Laboligen talibanisering.",
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
              bottomSheetWidget: BlocProvider<SessionDetailsBloc>(
                  create: (context) => SessionDetailsBloc(),
                  child: const CancelBooking()));
          // your stateful widget
        });
  }

  Widget getJoinNowAfterThreshHold() {
    return Visibility(
      visible: !widget.isPrevious && isCrossedThreshold,
      child: const AppCta(
        text: "Join now",
        isLoading: false,
      ),
    );
  }

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

  bool isCrossedThreshold = false;

  Widget getJoinNowBeforeThreshHold() {
    return Visibility(
      visible: !widget.isPrevious && !isCrossedThreshold,
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
                getStartingTime(05, 30, 19)
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
                children: const [
                  AppText(
                    "Per Session",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  AppText(
                    "(30 min)",
                    fontSize: 14,
                  ),
                ],
              ),
              const AppText(
                "₹150",
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
      decoration: BoxDecoration(
        color: AppColors.grey35,
        border: Border.all(width: 0.9, color: AppColors.grey32),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
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
                  "How to bifurcate time for each questions for NEET exam?",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey50,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getDateTimeOfSession() {
    return const AppText(
      "10 March, 02:15 PM -03:00 PM",
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
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
          return const AppAnimatedBottomSheet(
              bottomSheetWidget: ProfileBottomSheet()); // your stateful widget
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
                children: const [
                  AppText(
                    "Ikshit Anand",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  AppText(
                    "JEE main",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  AppText(
                    "+2 passed",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
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
