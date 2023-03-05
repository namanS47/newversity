import 'package:json_annotation/json_annotation.dart';

part 'response_status.g.dart';

@JsonSerializable()
class ResponseStatusModel {
  ResponseStatusModel();

  factory ResponseStatusModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseStatusModelFromJson(json);
  @JsonKey(name: "response_status")
  ResponseStatus? responseStatus;
}

@JsonSerializable()
class ResponseStatus {
  ResponseStatus({
    this.statusCode,
    this.messages,
    this.status,
  });

  factory ResponseStatus.fromJson(Map<String, dynamic> json) =>
      _$ResponseStatusFromJson(json);

  @JsonKey(name: "status_code")
  int? statusCode;
  List<Messages>? messages;
  String? status;
}

@JsonSerializable()
class Messages {
  Messages({
    this.code,
    this.type,
    this.message,
    this.args,
  });

  factory Messages.fromJson(Map<String, dynamic> json) =>
      _$MessagesFromJson(json);

  String? code;
  String? type;
  String? message;
  List<String?>? args;
}
