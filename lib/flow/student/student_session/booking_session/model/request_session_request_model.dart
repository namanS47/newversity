import 'package:json_annotation/json_annotation.dart';
part 'request_session_request_model.g.dart';

@JsonSerializable(
    createFactory: false, fieldRename: FieldRename.snake, includeIfNull: false)
class RequestSessionRequestModel {
  String? teacherId;
  String? studentId;
  String? agenda;
  List<String>? engagementType;
  String? info;
  String? location;
  String? forCreators;

  RequestSessionRequestModel(
      {this.teacherId,
        this.studentId,
        this.agenda,
        this.engagementType,
        this.info,
        this.location,
        this.forCreators});

  Map<String, dynamic> toJson() => _$RequestSessionRequestModelToJson(this);
}
