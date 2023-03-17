import 'package:json_annotation/json_annotation.dart';

part 'teacher_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TeacherDetails {
  String? teacherId;
  String? name;
  String? mobileNumber;
  String? email;
  String? introVideoUrl;
  String? location;
  String? gender;
  String? title;
  String? info;
  List<String>? uploadedDocuments;
  List<String>? tags;
  String? education;
  String? designation;
  String? profileUrl;
  String? profilePictureUrl;
  Map<String, double>? sessionPricing;
  String? language;
  bool? isNew;

  TeacherDetails({
    this.teacherId,
    this.name,
    this.mobileNumber,
    this.email,
    this.introVideoUrl,
    this.location,
    this.gender,
    this.title,
    this.info,
    this.uploadedDocuments,
    this.tags,
    this.education,
    this.designation,
    this.profileUrl,
    this.profilePictureUrl,
    this.sessionPricing,
    this.language,
    this.isNew
  });

  factory TeacherDetails.fromJson(Map<String, dynamic> json) => _$TeacherDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherDetailsToJson(this);
}
