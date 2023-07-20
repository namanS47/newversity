part of 'payment_bloc.dart';

@immutable
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class CreatePaymentOrderLoadingState extends PaymentState {}

class CreatePaymentOrderSuccessState extends PaymentState {}

class CreatePaymentOrderFailureState extends PaymentState {}

// class RazorpayPGLoadingState extends

class FetchPhonePePGUrlLoadingState extends PaymentState  {}

class  FetchPhonePePGUrlSuccessState extends PaymentState  {
  FetchPhonePePGUrlSuccessState({required this.phonePeCallbackUrlResponseModel});
  final PhonePeCallbackUrlResponseModel phonePeCallbackUrlResponseModel;
}

class FetchPhonePePGUrlFailureState extends PaymentState  {}

class FetchPhonePeTransactionStatusLoadingState extends PaymentState {}

class FetchPhonePeTransactionStatusSuccessState extends PaymentState {
  FetchPhonePeTransactionStatusSuccessState({required this.phonePeTransactionStatusResponseModel});
  final PhonePeTransactionStatusResponseModel? phonePeTransactionStatusResponseModel;
}

class FetchPhonePeTransactionStatusFailureState extends PaymentState {}

