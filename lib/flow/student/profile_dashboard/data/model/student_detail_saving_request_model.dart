import 'package:json_annotation/json_annotation.dart';

part 'student_detail_saving_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StudentDetailSavingRequestModel {
  String? studentId;
  String? name;
  String? mobileNumber;
  String? location;
  List<String>? tags;
  String? profilePictureUrl;
  List<String>? language;
  String? info;

  StudentDetailSavingRequestModel(
      {this.studentId,
      this.name,
      this.mobileNumber,
      this.location,
      this.tags,
      this.profilePictureUrl,
      this.language,
      this.info});

  factory StudentDetailSavingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$StudentDetailSavingRequestModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$StudentDetailSavingRequestModelToJson(this);
}
