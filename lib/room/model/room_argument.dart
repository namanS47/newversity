import '../../flow/student/student_session/my_session/model/session_detail_response_model.dart';

class RoomArguments {
  RoomArguments({required this.sessionDetails, required this.forStudents});
  final bool forStudents;
  final SessionDetailResponseModel sessionDetails;
}