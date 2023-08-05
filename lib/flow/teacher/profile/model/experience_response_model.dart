import 'package:json_annotation/json_annotation.dart';

part 'experience_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExperienceDetailsModel {
  String? id;
  String? teacherId;
  String? title;
  String? employmentType;
  String? companyName;
  String? location;
  DateTime? startDate;
  DateTime? endDate;
  bool? currentlyWorkingHere;

  ExperienceDetailsModel(
      {this.id,
      this.teacherId,
      this.title,
      this.employmentType,
      this.companyName,
      this.location,
      this.startDate,
      this.endDate,
      this.currentlyWorkingHere});

  factory ExperienceDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ExperienceDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceDetailsModelToJson(this);
}
