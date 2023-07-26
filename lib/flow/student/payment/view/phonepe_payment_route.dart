import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/payment/view/payment_processing.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/model/payment_argument.dart';
import '../data/model/payment_completion_argument.dart';
import '../payment_bloc/payment_bloc.dart';

class PhonePePaymentRoute extends StatefulWidget {
  const PhonePePaymentRoute({Key? key, required this.paymentArgument})
      : super(key: key);
  final PaymentArgument paymentArgument;

  @override
  State<PhonePePaymentRoute> createState() => _PhonePePaymentRouteState();
}

class _PhonePePaymentRouteState extends State<PhonePePaymentRoute> {
  late WebViewController _controller;

  @override
  void initState() {
    BlocProvider.of<PaymentBloc>(context)
        .add(FetchPhonePePGUrlEvent(paymentArgument: widget.paymentArgument));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onPaymentFailure();
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<PaymentBloc, PaymentState>(
            listener: (context, state) {
              if (state is FetchPhonePePGUrlSuccessState) {
                _controller = WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onProgress: (int progress) {
                        // Update loading bar.
                      },
                      onPageStarted: (String url) {},
                      onPageFinished: (String url) {},
                      onWebResourceError: (WebResourceError error) {},
                      onNavigationRequest: (NavigationRequest request) {
                        return NavigationDecision.navigate;
                      },
                      onUrlChange: (UrlChange change) {
                        if(change.url?.startsWith("https://www.newversity.in/") == true) {
                          BlocProvider.of<PaymentBloc>(context).add(FetchPhonePeTransactionStatusEvent());
                        }
                      },
                    ),
                  )
                  ..loadRequest(
                      Uri.parse(state.phonePeCallbackUrlResponseModel.response!)
                  );
              } else if(state is FetchPhonePeTransactionStatusSuccessState) {
                Navigator.pop(
                    context,
                    PaymentCompletionArgument(
                        isPaymentSuccess: true,
                        merchantTransactionId: state.phonePeTransactionStatusResponseModel?.merchantTransactionId,
                        paymentMedium: "phonepe"
                    ));
              } else if(state is FetchPhonePeTransactionStatusFailureState) {
                onPaymentFailure();
              }
            },
            builder: (context, state) {
              if (state is FetchPhonePePGUrlLoadingState || state is FetchPhonePeTransactionStatusLoadingState) {
                return const PaymentProcessingScreen();
              }
              if(state is FetchPhonePePGUrlSuccessState) {
                return WebViewWidget(controller: _controller);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void onPaymentFailure() {
    Navigator.pop(
        context,
        PaymentCompletionArgument(
            isPaymentSuccess: false,
            paymentMedium: "phonepe"
        ));
  }
}
