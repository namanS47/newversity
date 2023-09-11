
import 'package:json_annotation/json_annotation.dart';
part 'webinar_details_response_model.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class WebinarDetailsResponseModel {
  String? id;
  String? teacherId;
  String? teacherName;
  String? teacherTitle;
  String? teacherProfilePicture;
  String? shareLink;
  DateTime? webinarDate;
  List<StudentsInfoList>? studentsInfoList;
  String? title;
  String? feedback;
  String? rating;
  String? agenda;
  String? issueRaised;

  WebinarDetailsResponseModel(
      {this.id,
        this.teacherId,
        this.teacherName,
        this.teacherTitle,
        this.teacherProfilePicture,
        this.shareLink,
        this.webinarDate,
        this.studentsInfoList,
        this.title,
        this.feedback,
        this.rating,
        this.agenda,
        this.issueRaised});

  factory WebinarDetailsResponseModel.fromJson(Map<String, dynamic> json) => _$WebinarDetailsResponseModelFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StudentsInfoList {
  String? studentId;
  String? info;
  String? agenda;
  String? location;

  StudentsInfoList({this.studentId, this.info, this.agenda, this.location});

  factory StudentsInfoList.fromJson(Map<String, dynamic> json) => _$StudentsInfoListFromJson(json);

  Map<String, dynamic> toJson() => _$StudentsInfoListToJson(this);
}
