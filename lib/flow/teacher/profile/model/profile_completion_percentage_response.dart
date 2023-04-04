import 'package:json_annotation/json_annotation.dart';

part 'profile_completion_percentage_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProfileCompletionPercentageResponse {
  double? completePercentage;
  String? reason;
  String? suggestion;

  ProfileCompletionPercentageResponse(
      {this.completePercentage, this.reason, this.suggestion});

  factory ProfileCompletionPercentageResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ProfileCompletionPercentageResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProfileCompletionPercentageResponseToJson(this);
}
