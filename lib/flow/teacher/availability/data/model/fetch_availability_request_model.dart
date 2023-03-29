import 'package:json_annotation/json_annotation.dart';

part 'fetch_availability_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FetchAvailabilityRequestModel {
  FetchAvailabilityRequestModel({this.teacherId, this.date});

  String? teacherId;
  DateTime? date;

  factory FetchAvailabilityRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FetchAvailabilityRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$FetchAvailabilityRequestModelToJson(this);
}
