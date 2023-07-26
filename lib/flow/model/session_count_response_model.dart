
import 'package:json_annotation/json_annotation.dart';
part 'session_count_response_model.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class SessionCountResponseModel {
  int? totalSessionCount;
  int? upcomingSessionCount;
  int? previousSessionCount;

  SessionCountResponseModel(
      {this.totalSessionCount,
        this.upcomingSessionCount,
        this.previousSessionCount});

  factory SessionCountResponseModel.fromJson(Map<String, dynamic> json) => _$SessionCountResponseModelFromJson(json);
}
