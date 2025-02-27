import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';

part 'availability_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AvailabilityModel {
  @JsonKey(name: "id")
  String? availabilityId;
  String? teacherId;
  DateTime? startDate;
  DateTime? endDate;
  String? sessionType;
  bool? booked;
  int? totalBooked;

  AvailabilityModel({
    this.availabilityId,
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
