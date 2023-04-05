import 'package:json_annotation/json_annotation.dart';

part 'session_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionDetailsResponse {
  String? id;
  String? teacherId;
  String? studentId;
  DateTime? startDate;
  DateTime? endDate;
  double? amount;
  String? sessionType;
  String? agenda;
  String? paymentId;
  String? mentorNote;
  String? studentFeedback;
  int? studentRating;
  bool? cancelled;

  SessionDetailsResponse(
      {this.id,
      this.teacherId,
      this.studentId,
      this.startDate,
      this.endDate,
      this.amount,
      this.sessionType,
      this.agenda,
      this.paymentId,
      this.mentorNote,
      this.studentFeedback,
      this.studentRating,
      this.cancelled});

  factory SessionDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SessionDetailsResponseToJson(this);
}
