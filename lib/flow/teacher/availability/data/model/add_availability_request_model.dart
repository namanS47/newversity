import 'package:json_annotation/json_annotation.dart';

import 'availability_model.dart';

part 'add_availability_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddAvailabilityRequestModel {
  List<AvailabilityModel>? availabilityList;

  AddAvailabilityRequestModel({this.availabilityList});

  factory AddAvailabilityRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddAvailabilityRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddAvailabilityRequestModelToJson(this);
}
