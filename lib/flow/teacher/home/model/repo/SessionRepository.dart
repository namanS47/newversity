import 'package:dio/dio.dart';
import 'package:newversity/flow/teacher/home/model/session_request_model.dart';
import 'package:newversity/flow/teacher/home/model/session_response_model.dart';
import 'package:newversity/flow/teacher/webservice/teacher_base_repository.dart';
import 'package:newversity/network/api/teacher_api.dart';

import '../../../../../di/di_initializer.dart';
import '../../../../../network/webservice/exception.dart';
import '../../../data/model/teacher_details/teacher_details.dart';

class SessionRepository extends TeacherBaseRepository {
  final TeacherApi _teacherApi = DI.inject<TeacherApi>();

  Future<List<SessionDetailsResponse>?> getSessionDetails(
      String type) async {
    List<SessionDetailsResponse>? listOfSessionDetails = [];
    try {
      listOfSessionDetails = await _teacherApi.getSessionDetails(type);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfSessionDetails;
  }

  Future<void> saveSessionDetail(
      SessionSaveRequest sessionSaveRequest) async {
    try {
      await _teacherApi.addSessionDetail(sessionSaveRequest);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }


  Future<TeacherDetails?> getStudentDetails(String studentId) async {
    TeacherDetails? response = TeacherDetails();
    try {
      response = await _teacherApi.getTeacherDetails(studentId);
    } on DioError catch (exception) {
      AppException.forException(exception.response);
    }
    return response;
  }

}
