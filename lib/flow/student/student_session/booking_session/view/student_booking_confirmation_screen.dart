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
  final TextEditingController _promoCodeController = TextEditingController();

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
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
                        showError
                            ? const AppText(
                                "agenda can't be empty",
                                color: AppColors.redColorShadow400,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )
                            : Container()
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    _promoWidget()
                  ],
                ),
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

  Widget _promoWidget() {
    return BlocBuilder<StudentSessionBloc, StudentSessionStates>(
        builder: (context, state) {
        double? discount;
        if(state is FetchPromoCodeDetailsSuccessState) {
          discount = widget.sessionBookingArgument.amount *
              (state.promoCodeDetails.percentageDiscount!) /
              100;
        }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Promo Code",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          AppTextFormField(
            controller: _promoCodeController,
            suffix: InkWell(
              onTap: () {
                context.read<StudentSessionBloc>().add(
                    FetchPromoCodeDetailsEvent(
                        promoCode: _promoCodeController.text));
              },
              child: const Text(
                "Apply",
                style: TextStyle(
                    color: AppColors.redColorShadow400,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (state is FetchPromoCodeDetailsFailureState)
            Text(
              state.message ?? "",
              style: const TextStyle(color: AppColors.redColorShadow400),
            ),
          if (state is FetchPromoCodeDetailsSuccessState)
            const Text(
              "Promo code applied",
              style: TextStyle(color: AppColors.cyanBlue, fontWeight: FontWeight.bold),
            ),
          if (state is FetchPromoCodeDetailsSuccessState)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Order Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    const Text(
                      "Order Amount",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      widget.sessionBookingArgument.amount.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    const Text(
                      "Discount",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      "-${discount.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      (widget.sessionBookingArgument.amount - (discount ?? 0))
                          .toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
          AppCta(
            onTap: () => onTapPayConfirm(widget.sessionBookingArgument.amount - (discount ?? 0)),
            text: "Pay ₹${widget.sessionBookingArgument.amount - (discount ?? 0)}",
            isLoading: isLoading,
          ),
        ],
      );
    });
  }

  onTapPayConfirm(double amount) async {
    if (isFormValid()) {
      isLoading = true;

      /// For Razorpay PG page
      // final paymentResult =
      //     await Navigator.of(context).pushNamed(AppRoutes.paymentRoute,
      //         arguments: PaymentArgument(
      //           amount: widget.sessionBookingArgument.amount.toInt() * 100,
      //           availabilityId: widget.sessionBookingArgument.availabilityId,
      //         )) as PaymentCompletionArgument;

      /// For PhonePe PG page
      final paymentResult =
          await Navigator.of(context).pushNamed(AppRoutes.phonePePaymentRoute,
              arguments: PaymentArgument(
                amount: amount.toInt() * 100,
                availabilityId: widget.sessionBookingArgument.availabilityId,
              )) as PaymentCompletionArgument;

      if (context.mounted) {
        if (paymentResult.isPaymentSuccess) {
          BlocProvider.of<StudentSessionBloc>(context).add(SessionAddingEvent(
            sessionSaveRequest: SessionSaveRequest(
                teacherId: widget.sessionBookingArgument.teacherId,
                studentId: widget.sessionBookingArgument.studentId,
                sessionType: widget.sessionBookingArgument.sessionType,
                startDate: widget.sessionBookingArgument.startTime,
                agenda: _agendaController.text,
                endDate: widget.sessionBookingArgument.endTime,
                amount: amount,
                paymentId: paymentResult.paymentId,
                orderId: paymentResult.orderId,
                availabilityId: widget.sessionBookingArgument.availabilityId,
                paymentMedium: paymentResult.paymentMedium,
                merchantTransactionId: paymentResult.merchantTransactionId),
          ));
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.paymentError);
        }
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
                keyboardType: TextInputType.text,
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
