class PaymentCompletionArgument {
  PaymentCompletionArgument({
    required this.isPaymentSuccess,
    this.paymentId,
    this.orderId,
    this.errorMessage,
    this.merchantTransactionId,
    this.paymentMedium
  });

  final bool isPaymentSuccess;

  //Razorpay
  final String? paymentId;
  final String? orderId;
  final String? errorMessage;

  //For PhonePe
  String? merchantTransactionId;
  String? paymentMedium;
}
