class PaymentCompletionArgument {
  PaymentCompletionArgument({
    required this.isPaymentSuccess,
    this.paymentId,
    this.orderId,
    this.errorMessage
  });

  final bool isPaymentSuccess;
  final String? paymentId;
  final String? orderId;
  final String? errorMessage;
}
