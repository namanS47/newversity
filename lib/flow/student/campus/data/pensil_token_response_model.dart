import 'package:json_annotation/json_annotation.dart';
part 'pensil_token_response_model.g.dart';

@JsonSerializable(createToJson: false)
class PensilTokenResponseModel {
  User? user;

  PensilTokenResponseModel({this.user});

  factory PensilTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PensilTokenResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class User {
  String? id;
  String? name;
  bool? isVerifiedByPensil;
  String? countryCode;
  String? userId;
  String? picture;
  String? role;
  String? createdAt;
  String? updatedAt;
  String? token;
  String? communityTypeSelection;

  User(
      {this.id,
      this.name,
      this.isVerifiedByPensil,
      this.countryCode,
      this.userId,
      this.picture,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.token,
      this.communityTypeSelection});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
