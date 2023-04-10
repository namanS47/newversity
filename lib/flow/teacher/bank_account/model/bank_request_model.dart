import 'package:json_annotation/json_annotation.dart';

part 'bank_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddBankRequestModel {
  String? teacherId;
  String? accountNumber;
  String? accountName;
  String? ifscCode;

  AddBankRequestModel(
      {this.teacherId, this.accountNumber, this.accountName, this.ifscCode});

  factory AddBankRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddBankRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddBankRequestModelToJson(this);
}
