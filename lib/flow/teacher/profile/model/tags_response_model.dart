import 'package:json_annotation/json_annotation.dart';

part 'tags_response_model.g.dart';

@JsonSerializable( fieldRename: FieldRename.none)
class TagsResponseModel {
  String? tagName;
  List<String>? teacherIdList;
  String? tagCategory;
  String? id;

  @override
  String toString() {
    return 'TagsResponseModel{tagName: $tagName, teacherIdList: $teacherIdList, tagCategory: $tagCategory, id: $id, createdAt: $createdAt, modifiedAt: $modifiedAt, createdBy: $createdBy, modifiedBy: $modifiedBy, isDeleted: $isDeleted}';
  }

  String? createdAt;
  String? modifiedAt;
  String? createdBy;
  String? modifiedBy;
  bool? isDeleted;

  TagsResponseModel(
      {this.tagName,
      this.teacherIdList,
      this.tagCategory,
      this.id,
      this.createdAt,
      this.modifiedAt,
      this.createdBy,
      this.modifiedBy,
      this.isDeleted});

  factory TagsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TagsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagsResponseModelToJson(this);
}
