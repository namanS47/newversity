// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseStatusModel _$ResponseStatusModelFromJson(Map<String, dynamic> json) =>
    ResponseStatusModel()
      ..responseStatus = json['response_status'] == null
          ? null
          : ResponseStatus.fromJson(
              json['response_status'] as Map<String, dynamic>);

Map<String, dynamic> _$ResponseStatusModelToJson(
        ResponseStatusModel instance) =>
    <String, dynamic>{
      'response_status': instance.responseStatus,
    };

ResponseStatus _$ResponseStatusFromJson(Map<String, dynamic> json) =>
    ResponseStatus(
      statusCode: json['status_code'] as int?,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Messages.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ResponseStatusToJson(ResponseStatus instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'messages': instance.messages,
      'status': instance.status,
    };

Messages _$MessagesFromJson(Map<String, dynamic> json) => Messages(
      code: json['code'] as String?,
      type: json['type'] as String?,
      message: json['message'] as String?,
      args: (json['args'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    );

Map<String, dynamic> _$MessagesToJson(Messages instance) => <String, dynamic>{
      'code': instance.code,
      'type': instance.type,
      'message': instance.message,
      'args': instance.args,
    };
