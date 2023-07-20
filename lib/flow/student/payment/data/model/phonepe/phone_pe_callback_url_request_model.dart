import 'package:json_annotation/json_annotation.dart';
part 'phone_pe_callback_url_request_model.g.dart';

@JsonSerializable(createFactory: false)
class PhonePeCallbackUrlRequestModel {
  String? merchantTransactionId;
  String? merchantUserId;
  int? amount;
  String? mobileNumber;

  PhonePeCallbackUrlRequestModel(
      {this.merchantTransactionId,
        this.merchantUserId,
        this.amount,
        this.mobileNumber});

  Map<String, dynamic> toJson() => _$PhonePeCallbackUrlRequestModelToJson(this);
}