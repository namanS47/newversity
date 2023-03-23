import 'package:json_annotation/json_annotation.dart';

part 'tags_with_teacher_id_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TagsWithTeacherIdRequestModel {
  String? tagName;
  String? tagCategory;

  TagsWithTeacherIdRequestModel({this.tagName, this.tagCategory});

  factory TagsWithTeacherIdRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TagsWithTeacherIdRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagsWithTeacherIdRequestModelToJson(this);
}
