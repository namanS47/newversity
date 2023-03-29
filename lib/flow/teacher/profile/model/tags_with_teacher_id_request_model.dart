import 'package:json_annotation/json_annotation.dart';

part 'tags_with_teacher_id_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TagRequestModel {
  List<TagModel>? tagModelList;

  TagRequestModel({this.tagModelList});

  factory TagRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TagRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagRequestModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TagModel {
  String? tagName;
  String? tagCategory;

  TagModel({this.tagName, this.tagCategory});

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagModelToJson(this);
}
