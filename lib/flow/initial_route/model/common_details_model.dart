import 'package:json_annotation/json_annotation.dart';

part 'common_details_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class CommonDetailsModel {
  String? firebaseUserId;
  String? fcmToken;

  CommonDetailsModel({required this.firebaseUserId, required this.fcmToken});

  Map<String, dynamic> toJson() => _$CommonDetailsModelToJson(this);
}
