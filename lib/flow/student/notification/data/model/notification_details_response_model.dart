import 'package:json_annotation/json_annotation.dart';

part 'notification_details_response_model.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class NotificationDetailsResponseModel {
  String? userId;
  List<String>? userIds;
  String? title;
  String? body;
  Data? data;
  DateTime? date;

  NotificationDetailsResponseModel(
      {this.userId, this.userIds, this.title, this.body, this.data, this.date});

  factory NotificationDetailsResponseModel.fromJson(Map<String, dynamic> json) => _$NotificationDetailsResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Data {
  String? action;

  Data({this.action});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
