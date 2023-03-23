import 'package:json_annotation/json_annotation.dart';

part 'education_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EducationResponseModel {
  String? id;
  String? teacherId;
  String? name;
  String? degree;
  DateTime? startDate;
  DateTime? endDate;
  bool? currentlyWorkingHere;
  String? grade;

  EducationResponseModel(
      {this.id,
      this.teacherId,
      this.name,
      this.degree,
      this.startDate,
      this.endDate,
      this.currentlyWorkingHere,
      this.grade});

  factory EducationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EducationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$EducationResponseModelToJson(this);
}
