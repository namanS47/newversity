import 'package:json_annotation/json_annotation.dart';

part 'add_tag_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddTagRequestModel {
  List<TagModelList>? tagModelList;

  AddTagRequestModel({this.tagModelList});

  factory AddTagRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddTagRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddTagRequestModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TagModelList {
  String? tagName;
  String? tagCategory;

  TagModelList({this.tagName, this.tagCategory});

  factory TagModelList.fromJson(Map<String, dynamic> json) =>
      _$TagModelListFromJson(json);

  Map<String, dynamic> toJson() => _$TagModelListToJson(this);
}
