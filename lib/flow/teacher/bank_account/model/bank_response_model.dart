import 'package:json_annotation/json_annotation.dart';

part 'bank_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BankResponseModel {
  String? id;
  String? teacherId;
  String? accountNumber;
  String? accountName;
  String? ifscCode;

  BankResponseModel(
      {this.id,
      this.teacherId,
      this.accountNumber,
      this.accountName,
      this.ifscCode});

  factory BankResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BankResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankResponseModelToJson(this);
}
