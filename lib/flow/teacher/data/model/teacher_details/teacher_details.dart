import 'package:json_annotation/json_annotation.dart';

part 'teacher_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TeacherDetails {
  String? teacherId;
  String? name;
  String? mobileNumber;
  String? introVideoUrl;
  String? location;
  String? title;
  String? info;
  String? profileUrl;
  String? profilePictureUrl;
  List<String>? language;
  String? email;
  String? gender;
  List<String>? uploadedDocuments;

  @override
  String toString() {
    return 'TeacherDetails{teacherId: $teacherId, name: $name, mobileNumber: $mobileNumber, introVideoUrl: $introVideoUrl, location: $location, title: $title, info: $info, profileUrl: $profileUrl, profilePictureUrl: $profilePictureUrl, language: $language, email: $email, gender: $gender, uploadedDocuments: $uploadedDocuments, tags: $tags, education: $education, designation: $designation, sessionPricing: $sessionPricing, isNew: $isNew}';
  }

  List<String>? tags;
  String? education;
  String? designation;
  Map<String, double>? sessionPricing;
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
