import '../../../student/student_session/my_session/model/session_detail_response_model.dart';

class SessionDetailArguments {
  final String id;
  final bool isPrevious;
  final SessionDetailResponseModel sessionDetails;

  SessionDetailArguments({required this.id, required this.isPrevious, required this.sessionDetails});
}
