import 'package:json_annotation/json_annotation.dart';

import '../../../profile/model/tags_response_model.dart';

part 'teacher_details_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TeacherDetailsModel {
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
  DateTime? nextAvailable;

  @override
  String toString() {
    return 'TeacherDetails{teacherId: $teacherId, name: $name, mobileNumber: $mobileNumber, introVideoUrl: $introVideoUrl, location: $location, title: $title, info: $info, profileUrl: $profileUrl, profilePictureUrl: $profilePictureUrl, language: $language, email: $email, gender: $gender, uploadedDocuments: $uploadedDocuments, tags: $tags, education: $education, designation: $designation, sessionPricing: $sessionPricing, isNew: $isNew , nextAvailability: $nextAvailable}';
  }

  List<TagsResponseModel>? tags;
  String? education;
  String? designation;
  Map<String, double>? sessionPricing;
  bool? isNew;

  TeacherDetailsModel({
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
    this.isNew,
    this.nextAvailable
  });

  factory TeacherDetailsModel.fromJson(Map<String, dynamic> json) => _$TeacherDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherDetailsModelToJson(this);
}
