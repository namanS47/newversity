import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/payment/data/model/payment_argument.dart';
import 'package:newversity/flow/student/payment/data/model/payment_completion_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/bloc/student_session_bloc.dart';
import 'package:newversity/flow/teacher/home/model/session_request_model.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';

import '../../../../../themes/colors.dart';
import '../../../../../utils/date_time_utils.dart';
import '../model/session_bookin_argument.dart';

class StudentBookingConfirmationScreen extends StatefulWidget {
  final SessionBookingArgument sessionBookingArgument;

  const StudentBookingConfirmationScreen(
      {Key? key, required this.sessionBookingArgument})
      : super(key: key);

  @override
  State<StudentBookingConfirmationScreen> createState() =>
      _StudentBookingConfirmationScreenState();
}

class _StudentBookingConfirmationScreenState
    extends State<StudentBookingConfirmationScreen> {
  final _agendaController = TextEditingController();
  bool showError = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSessionBloc, StudentSessionStates>(
      listener: (context, state) {
        if (state is BookedSessionState) {
          isLoading = false;
          Navigator.of(context).pushNamed(AppRoutes.paymentSuccessful);
        }
      },
      builder: (context, state) {
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
                          onTap: () => {Navigator.pop(context)},
                          child: const AppImage(image: ImageAsset.arrowBack)),
                      const SizedBox(
                        height: 30,
                      ),
                      const AppText(
                        "Confirm your booking",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      getDateTimeOfSession(),
                      const SizedBox(
                        height: 30,
                      ),
                      getAgendaContainer(context),
                    ],
                  )),
                  AppCta(
                    onTap: () => onTapPayConfirm(),
                    text: "Pay ₹${widget.sessionBookingArgument.amount}",
                    isLoading: false,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool isFormValid() {
    return widget.sessionBookingArgument.teacherId.isNotEmpty &&
        widget.sessionBookingArgument.studentId.isNotEmpty &&
        _agendaController.text.isNotEmpty;
  }

  onTapPayConfirm() async {
    if (isFormValid()) {
      isLoading = true;

      final paymentResult =
          await Navigator.of(context).pushNamed(AppRoutes.paymentRoute,
              arguments: PaymentArgument(
                amount: widget.sessionBookingArgument.amount.toInt() * 100,
                availabilityId: widget.sessionBookingArgument.availabilityId,
              )) as PaymentCompletionArgument;

      if (paymentResult.isPaymentSuccess) {
        BlocProvider.of<StudentSessionBloc>(context).add(
          SessionAddingEvent(
            sessionSaveRequest: SessionSaveRequest(
              teacherId: widget.sessionBookingArgument.teacherId,
              studentId: widget.sessionBookingArgument.studentId,
              sessionType: widget.sessionBookingArgument.sessionType,
              startDate: widget.sessionBookingArgument.startTime,
              endDate: widget.sessionBookingArgument.endTime,
              amount: widget.sessionBookingArgument.amount,
              paymentId: paymentResult.paymentId,
              orderId: paymentResult.orderId
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Something went wrong",
            ),
          ),
        );
      }
    } else {
      isLoading = false;
      showError = true;
      setState(() {});
    }
  }

  Widget getAgendaContainer(context) {
    return Container(
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
                controller: _agendaController,
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

  String getTimeText() {
    String text = "";
    text =
        "${DateTimeUtils.getBirthFormattedDateTime(widget.sessionBookingArgument.startTime)} ${DateTimeUtils.getTimeInAMOrPM(widget.sessionBookingArgument.startTime)} - ${DateTimeUtils.getTimeInAMOrPM(widget.sessionBookingArgument.endTime)}";
    return text;
  }

  Widget getDateTimeOfSession() {
    String timeText = getTimeText();
    return AppText(
      timeText,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }
}
