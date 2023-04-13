import 'package:json_annotation/json_annotation.dart';

part 'student_details_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StudentDetail {
  String? studentId;
  String? name;
  String? mobileNumber;
  String? email;

  @override
  String toString() {
    return 'StudentDetail{studentId: $studentId, name: $name, mobileNumber: $mobileNumber, email: $email, location: $location, tags: $tags, profilePictureUrl: $profilePictureUrl, language: $language, info: $info}';
  }

  String? location;
  List<String>? tags;
  String? profilePictureUrl;
  List<String>? language;
  String? info;

  StudentDetail(
      {this.studentId,
      this.name,
      this.mobileNumber,
      this.email,
      this.location,
      this.tags,
      this.profilePictureUrl,
      this.language,
      this.info});

  factory StudentDetail.fromJson(Map<String, dynamic> json) =>
      _$StudentDetailFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDetailToJson(this);
}
