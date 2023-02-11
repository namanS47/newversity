
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserData {
  @JsonKey(name: "user_id")
  String userId;

  String name;

  @JsonKey(name: "phone_number")
  String phoneNumber;

  @JsonKey(name: "profile_url")
  String? profileUrl;

  UserData({required this.userId, required this.name, required this.phoneNumber, this.profileUrl});

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}