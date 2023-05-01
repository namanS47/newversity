import 'package:json_annotation/json_annotation.dart';

part 'create_order_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CreateOrderResponseModel {
  int? amount;
  int? amountPaid;
  Notes? notes;
  int? createdAt;
  int? amountDue;
  String? currency;
  String? receipt;
  String? id;
  String? entity;
  String? offerId;
  String? status;
  int? attempts;

  CreateOrderResponseModel(
      {this.amount,
      this.amountPaid,
      this.notes,
      this.createdAt,
      this.amountDue,
      this.currency,
      this.receipt,
      this.id,
      this.entity,
      this.offerId,
      this.status,
      this.attempts});

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseModelFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Notes {
  String? studentId;
  String? availabilityId;

  Notes({this.studentId, this.availabilityId});

  factory Notes.fromJson(Map<String, dynamic> json) => _$NotesFromJson(json);

  Map<String, dynamic> toJson() => _$NotesToJson(this);
}
