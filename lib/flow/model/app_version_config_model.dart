import 'package:json_annotation/json_annotation.dart';
part 'app_version_config_model.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class AppVersionConfigModel {
  bool? mandatory;
  String? version;

  AppVersionConfigModel({this.version, this.mandatory});

  factory AppVersionConfigModel.fromJson(Map<String, dynamic> json) => _$AppVersionConfigModelFromJson(json);
}
