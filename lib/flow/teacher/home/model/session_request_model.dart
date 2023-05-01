import 'package:json_annotation/json_annotation.dart';

part 'session_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionSaveRequest {
  String? id;
  String? teacherId;
  String? studentId;
  DateTime? startDate;
  DateTime? endDate;
  double? amount;
  String? sessionType;
  String? agenda;
  String? paymentId;
  String? orderId;
  String? availabilityId;
  String? mentorNote;
  String? studentFeedback;
  double? studentRating;
  bool? cancelled;
  List<String>? issueRaised;

  SessionSaveRequest(
      {this.id,
      this.teacherId,
      this.studentId,
      this.startDate,
      this.endDate,
      this.amount,
      this.sessionType,
      this.agenda,
      this.paymentId,
      this.orderId,
      this.availabilityId,
      this.mentorNote,
      this.studentFeedback,
      this.studentRating,
      this.issueRaised,
      this.cancelled});

  factory SessionSaveRequest.fromJson(Map<String, dynamic> json) =>
      _$SessionSaveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SessionSaveRequestToJson(this);
}
