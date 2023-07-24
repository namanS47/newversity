import 'package:json_annotation/json_annotation.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';

part 'session_detail_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionDetailResponseModel {
  String? id;
  String? teacherId;
  String? studentId;
  TeacherDetailsModel? teacherDetail;
  StudentDetailForSession? studentDetail;
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
