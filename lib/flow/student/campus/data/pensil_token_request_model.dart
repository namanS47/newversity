import 'package:json_annotation/json_annotation.dart';
part 'pensil_token_request_model.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class PensilTokenRequestModel {
  String referenceIdInSource;
  bool? createUser;
  String name;
  String? picture;
  String? description;

  PensilTokenRequestModel(
      {required this.referenceIdInSource,
        this.createUser,
        required this.name,
        this.picture,
        this.description});

  Map<String, dynamic> toJson() => _$PensilTokenRequestModelToJson(this);
}
