import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/payment/data/model/payment_argument.dart';
import 'package:newversity/flow/student/payment/payment_bloc/payment_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../config/app_config.dart';

class PaymentRoute extends StatefulWidget {
  const PaymentRoute({Key? key, required this.paymentArgument}) : super(key: key);
  final PaymentArgument paymentArgument;

  @override
  State<PaymentRoute> createState() => _PaymentRouteState();
}

class _PaymentRouteState extends State<PaymentRoute> {
  late Razorpay _razorPay;
  @override
  void initState() {
    BlocProvider.of<PaymentBloc>(context).add(CreatePaymentOrderEvent(paymentArgument: widget.paymentArgument));
    _razorPay = Razorpay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<PaymentBloc, PaymentState> (
          listener: (context, state) {
            if(state is CreatePaymentOrderSuccessState) {
              openRazorPayPG();
            }
          },
          builder: (context, state) {
            if(state is CreatePaymentOrderLoadingState) {
              return const Center(child: CircularProgressIndicator(),);
            }
            // if(state is CreatePaymentOrderSuccessState) {
            //   return Container();
            // }
            return Container();
          },
        ),
      ),
    );
  }

  void openRazorPayPG() {
    final orderDetails = context.read<PaymentBloc>().orderResponseDetails;
    final mobileNumber = context.read<PaymentBloc>().mobileNumber;
    var options = {
      'key': AppConfig.instance.config.razorPayKey,
      'amount': orderDetails?.amount,
      'name': orderDetails?.notes?.studentId,
      'description': '',
      // 'image':
      // 'https://www.bitclass.live/static/__assets__/BitClassLogos/LogoForWhiteBg.svg',
      'theme.color': '#2E3A59',
      'currency': orderDetails?.currency,
      'order_id': orderDetails?.id,
      'prefill': {'contact': mobileNumber},
      'notes': orderDetails?.notes?.toJson()
    };

    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
            (PaymentSuccessResponse paymentSuccessResponse) {

        });

    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
            (PaymentFailureResponse paymentFailureResponse) {

        });

    _razorPay.open(options);
  }
}

