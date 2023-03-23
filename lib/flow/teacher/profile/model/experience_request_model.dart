import 'package:json_annotation/json_annotation.dart';

part 'experience_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExperienceRequestModel {
  String? teacherId;
  String? title;
  String? employmentType;
  String? companyName;

  ExperienceRequestModel(
      {this.teacherId, this.title, this.employmentType, this.companyName});

  factory ExperienceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExperienceRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceRequestModelToJson(this);
}
