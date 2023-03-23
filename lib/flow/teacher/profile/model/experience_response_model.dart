import 'package:json_annotation/json_annotation.dart';

part 'experience_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExperienceResponseModel {
  String? id;
  String? teacherId;
  String? title;
  String? employmentType;
  String? companyName;
  String? location;
  String? startDate;
  String? endDate;
  String? currentlyWorkingHere;

  ExperienceResponseModel(
      {this.id,
      this.teacherId,
      this.title,
      this.employmentType,
      this.companyName,
      this.location,
      this.startDate,
      this.endDate,
      this.currentlyWorkingHere});

  factory ExperienceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExperienceResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceResponseModelToJson(this);
}
