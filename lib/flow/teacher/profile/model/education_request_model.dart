import 'package:json_annotation/json_annotation.dart';

part 'education_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EducationRequestModel {
  String? teacherId;
  String? name;
  String? degree;
  DateTime? startDate;
  DateTime? endDate;
  bool? currentlyWorkingHere;
  String? grade;

  EducationRequestModel(
      {this.teacherId,
      this.name,
      this.degree,
      this.startDate,
      this.endDate,
      this.currentlyWorkingHere,
      this.grade});

  factory EducationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EducationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$EducationRequestModelToJson(this);
}
