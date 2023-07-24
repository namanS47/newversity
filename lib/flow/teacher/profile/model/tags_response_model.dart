import 'package:json_annotation/json_annotation.dart';

part 'tags_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TagsResponseModel {
  String? tagName;

  @override
  String toString() {
    return 'TagsResponseModel{tagName: $tagName, tagCategory: $tagCategory, teacherTagDetailList: $teacherTagDetailList, teacherTagDetails: $teacherTagDetails}';
  }

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

  Map<String, dynamic> toJson() => _$TagsResponseModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TeacherTagDetails {
  String? tagStatus;
  List<String>? documents;
  String? reason;
  String? suggestion;

  TeacherTagDetails(
      {this.tagStatus, this.documents, this.reason, this.suggestion});

  factory TeacherTagDetails.fromJson(Map<String, dynamic> json) => _$TeacherTagDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherTagDetailsToJson(this);
}
