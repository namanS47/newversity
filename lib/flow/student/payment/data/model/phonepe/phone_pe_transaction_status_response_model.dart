import 'package:json_annotation/json_annotation.dart';

part 'phone_pe_transaction_status_response_model.g.dart';

@JsonSerializable(createToJson: false)
class PhonePeTransactionStatusResponseModel {
  String? merchantTransactionId;
  PhonePeTransactionDetailsData? phonePeTransactionDetailsData;

  PhonePeTransactionStatusResponseModel(
      {this.merchantTransactionId, this.phonePeTransactionDetailsData});

  factory PhonePeTransactionStatusResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$PhonePeTransactionStatusResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class PhonePeTransactionDetailsData {
  bool? success;
  String? code;
  String? message;
  Data? data;

  PhonePeTransactionDetailsData(
      {this.success, this.code, this.message, this.data});

  factory PhonePeTransactionDetailsData.fromJson(Map<String, dynamic> json) =>
      _$PhonePeTransactionDetailsDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class Data {
  String? merchantId;
  String? merchantTransactionId;
  String? transactionId;
  int? amount;
  String? state;
  String? responseCode;
  String? responseCodeDescription;
  PaymentInstrument? paymentInstrument;

  Data(
      {this.merchantId,
      this.merchantTransactionId,
      this.transactionId,
      this.amount,
      this.state,
      this.responseCode,
      this.responseCodeDescription,
      this.paymentInstrument});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@JsonSerializable(createToJson: false)
class PaymentInstrument {
  String? bankTransactionId;
  String? bankId;
  String? pgTransactionId;
  String? type;
  String? pgServiceTransactionId;

  PaymentInstrument(
      {this.bankTransactionId,
      this.bankId,
      this.pgTransactionId,
      this.type,
      this.pgServiceTransactionId});

  factory PaymentInstrument.fromJson(Map<String, dynamic> json) =>
      _$PaymentInstrumentFromJson(json);
}
