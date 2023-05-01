import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/bookings/bloc/session_details_bloc/booking_session_details_bloc.dart';

import '../../../../../themes/colors.dart';

class CancelBooking extends StatefulWidget {
  const CancelBooking({Key? key}) : super(key: key);

  @override
  State<CancelBooking> createState() => _CancelBookingState();
}

class _CancelBookingState extends State<CancelBooking> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingSessionDetailsBloc, BookingSessionDetailsStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              getCancelHeader(),
              const SizedBox(
                height: 10,
              ),
              const AppText(
                "Request for cancelling",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 20,
              ),
              getCancelRequestLayout(),
              const SizedBox(
                height: 20,
              ),
              getOtherReasonTextField(),
              const SizedBox(
                height: 40,
              ),
              AppCta(
                  onTap: () => onCancelRequest(),
                  isEnable: context
                      .read<BookingSessionDetailsBloc>()
                      .selectedCancelRequest
                      .isNotEmpty,
                  isLoading: false,
                  text: "Cancel booking")
            ],
          ),
        );
      },
    );
  }

  onCancelRequest() {}

  Widget getOtherReasonTextField() {
    return Visibility(
      visible: context
          .read<BookingSessionDetailsBloc>()
          .selectedCancelRequest
          .contains("Others"),
      child: const AppTextFormField(
        maxLines: 3,
        hintText: "Enter the reason here",
      ),
    );
  }

  Widget getCancelRequestLayout() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        context.read<BookingSessionDetailsBloc>().listOfCancelRequest.length,
        (curIndex) {
          return cancelRequestView(curIndex);
        },
      ),
    );
  }

  Widget cancelRequestView(int curIndex) {
    return GestureDetector(
      onTap: () => onSelectedCancelRequest(curIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: context
                    .read<BookingSessionDetailsBloc>()
                    .selectedCancelRequest
                    .contains(context
                        .read<BookingSessionDetailsBloc>()
                        .listOfCancelRequest[curIndex])
                ? AppColors.lightCyan
                : AppColors.grey35,
            border: Border.all(width: 0.3, color: AppColors.grey32)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            context.read<BookingSessionDetailsBloc>().listOfCancelRequest[curIndex],
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  onSelectedCancelRequest(int index) {
    BlocProvider.of<BookingSessionDetailsBloc>(context).add(CancelRequestSelectEvent(
        item: context.read<BookingSessionDetailsBloc>().listOfCancelRequest[index]));
  }

  Widget getCancelHeader() {
    return const AppText(
      "Cancel Booking",
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }
}
