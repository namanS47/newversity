part of 'payment_bloc.dart';

@immutable
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class CreatePaymentOrderLoadingState extends PaymentState {}

class CreatePaymentOrderSuccessState extends PaymentState {}

class CreatePaymentOrderFailureState extends PaymentState {}

// class RazorpayPGLoadingState extends

