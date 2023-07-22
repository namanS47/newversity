import 'package:json_annotation/json_annotation.dart';

part 'profile_completion_percentage_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ProfileCompletionPercentageResponse {
  double? completePercentage;
  String? reason;
  String? suggestion;
  Map<String, bool>? profileCompletionStageStatus;

  ProfileCompletionPercentageResponse(
      {this.completePercentage, this.reason, this.suggestion, this.profileCompletionStageStatus});

  factory ProfileCompletionPercentageResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ProfileCompletionPercentageResponseFromJson(json);
}

enum ProfileCompletionStage {
  VerifiedTags, SelectTags, Pricing, Experience, Education, Profile
}


