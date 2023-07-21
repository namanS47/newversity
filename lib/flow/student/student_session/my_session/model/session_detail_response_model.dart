import 'package:json_annotation/json_annotation.dart';

part 'session_detail_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionDetailResponseModel {
  String? id;
  String? teacherId;
  String? studentId;
  TeacherDetailForSession? teacherDetail;
  StudentDetailForSession? studentDetail;
  List<TeacherTagList>? teacherTagList;
  DateTime? startDate;
  DateTime? endDate;
  double? amount;
  String? sessionType;
  String? agenda;
  String? paymentId;
  String? mentorNote;
  String? studentFeedback;
  double? studentRating;
  String? teacherToken;
  String? studentToken;
  bool? cancelled;

  SessionDetailResponseModel(
      {this.id,
      this.teacherId,
      this.studentId,
      this.teacherDetail,
      this.studentDetail,
      this.teacherTagList,
      this.startDate,
      this.endDate,
      this.amount,
      this.sessionType,
      this.agenda,
      this.paymentId,
      this.mentorNote,
      this.studentFeedback,
      this.studentRating,
      this.teacherToken,
      this.studentToken,
      this.cancelled});

  factory SessionDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SessionDetailResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionDetailResponseModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TeacherDetailForSession {
  String? userId;
  String? teacherId;
  String? name;
  String? mobileNumber;
  String? email;
  String? introVideoUrl;
  String? location;
  String? gender;
  String? age;
  String? title;
  String? info;
  List<String>? uploadedDocuments;
  List<String>? tags;
  String? education;
  String? designation;
  String? profileUrl;
  String? profilePictureUrl;
  SessionPricing? sessionPricing;
  List<String>? language;
  bool? isNew;

  TeacherDetailForSession(
      {this.userId,
      this.teacherId,
      this.name,
      this.mobileNumber,
      this.email,
      this.introVideoUrl,
      this.location,
      this.gender,
      this.age,
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
      this.isNew});

  factory TeacherDetailForSession.fromJson(Map<String, dynamic> json) =>
      _$TeacherDetailForSessionFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherDetailForSessionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionPricing {
  double? short;
  double? long;

  SessionPricing({this.short, this.long});

  factory SessionPricing.fromJson(Map<String, dynamic> json) =>
      _$SessionPricingFromJson(json);

  Map<String, dynamic> toJson() => _$SessionPricingToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TeacherTagList {
  String? tagName;
  String? tagCategory;
  Map<String, TeacherTagDetails>? teacherTagDetailList;
  TeacherTagDetails? teacherTagDetails;

  TeacherTagList(
      {this.tagName,
      this.tagCategory,
      this.teacherTagDetailList,
      this.teacherTagDetails});

  factory TeacherTagList.fromJson(Map<String, dynamic> json) =>
      _$TeacherTagListFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherTagListToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TeacherTagDetails {
  String? tagStatus;
  List<String>? documents;
  String? reason;
  String? suggestion;

  TeacherTagDetails(
      {this.tagStatus, this.documents, this.reason, this.suggestion});

  factory TeacherTagDetails.fromJson(Map<String, dynamic> json) =>
      _$TeacherTagDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherTagDetailsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StudentDetailForSession {
  String? studentId;
  String? name;
  String? mobileNumber;
  String? email;
  String? location;
  List<String>? tags;
  String? profilePictureUrl;
  List<String>? language;
  String? info;

  StudentDetailForSession(
      {this.studentId,
      this.name,
      this.mobileNumber,
      this.email,
      this.location,
      this.tags,
      this.profilePictureUrl,
      this.language,
      this.info});

  factory StudentDetailForSession.fromJson(Map<String, dynamic> json) =>
      _$StudentDetailForSessionFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDetailForSessionToJson(this);
}
