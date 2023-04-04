import 'package:json_annotation/json_annotation.dart';

part 'tags_response_model.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class TagsResponseModel {
  String? tagName;
  String? tagCategory;

  Map<String, TeacherTagDetails>? teacherTagDetailList;
  TeacherTagDetails? teacherTagDetails;

  TagsResponseModel({
    this.tagName,
    this.tagCategory,
    this.teacherTagDetailList,
    this.teacherTagDetails,
  });

  factory TagsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TagsResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class TeacherTagDetails {
  String? tagStatus;
  List<String>? documents;
  String? reason;
  String? suggestion;

  TeacherTagDetails(
      {this.tagStatus, this.documents, this.reason, this.suggestion});

  factory TeacherTagDetails.fromJson(Map<String, dynamic> json) => _$TeacherTagDetailsFromJson(json);
}
