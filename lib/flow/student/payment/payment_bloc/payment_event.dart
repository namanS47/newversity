part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent {}


class CreatePaymentOrderEvent extends PaymentEvent {
  CreatePaymentOrderEvent({required this.paymentArgument});
  final PaymentArgument paymentArgument;
}

class OnPaymentSuccessEvent extends PaymentEvent {}

class OnPaymentFailureEvent extends PaymentEvent {}

class FetchPhonePePGUrlEvent extends PaymentEvent {
  FetchPhonePePGUrlEvent({required this.paymentArgument});
  final PaymentArgument paymentArgument;
}

class FetchPhonePeTransactionStatusEvent extends PaymentEvent {}