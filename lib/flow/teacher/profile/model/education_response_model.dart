import 'package:json_annotation/json_annotation.dart';

part 'education_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EducationDetailsModel {
  String? id;
  String? teacherId;
  String? name;
  String? degree;
  DateTime? startDate;
  DateTime? endDate;
  bool? currentlyWorkingHere;
  String? grade;

  EducationDetailsModel(
      {this.id,
      this.teacherId,
      this.name,
      this.degree,
      this.startDate,
      this.endDate,
      this.currentlyWorkingHere,
      this.grade});

  factory EducationDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$EducationDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EducationDetailsModelToJson(this);
}
