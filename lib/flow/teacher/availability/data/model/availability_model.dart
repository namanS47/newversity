import 'package:json_annotation/json_annotation.dart';
part 'availability_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AvailabilityModel {
  String? teacherId;
  DateTime? startDate;
  DateTime? endDate;
  String? sessionType;
  bool? booked;
  int? totalBooked;

  AvailabilityModel({
    this.teacherId,
    this.startDate,
    this.endDate,
    this.sessionType,
    this.booked,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvailabilityModelToJson(this);
}