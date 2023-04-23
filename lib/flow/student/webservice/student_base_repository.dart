import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/add_tag_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_detail_saving_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/student/student_session/my_session/model/session_detail_response_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:newversity/network/api/student_api.dart';
import 'package:newversity/network/webservice/base_repository.dart';

import '../../../di/di_initializer.dart';
import '../../../network/webservice/exception.dart';
import '../../teacher/availability/data/model/availability_model.dart';
import '../../teacher/availability/data/model/fetch_availability_request_model.dart';
import '../../teacher/home/model/session_request_model.dart';
import '../../teacher/profile/model/profile_completion_percentage_response.dart';

class StudentBaseRepository extends BaseRepository {
  final StudentApi _studentApi = DI.inject<StudentApi>();

  Future<StudentDetail?> saveStudentDetails(
      StudentDetailSavingRequestModel studentDetailSavingRequestModel,
      String studentId) async {
    try {
      return await _studentApi.saveStudentDetails(
          studentDetailSavingRequestModel, studentId);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> addTags(AddTagRequestModel addTagRequestModel) async {
    try {
      return await _studentApi.addListOfTags(addTagRequestModel);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<StudentDetail?> fetchStudentDetails(String studentId) async {
    try {
      return await _studentApi.getStudentDetails(studentId);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<ProfileCompletionPercentageResponse?> getProfileCompletionInfo(
      String studentId) async {
    ProfileCompletionPercentageResponse? response =
        ProfileCompletionPercentageResponse();
    try {
      response = await _studentApi.getProfileCompletionInfo(studentId);
    } on DioError catch (exception) {
      AppException.forException(exception.response);
    }
    return response;
  }

  Future<SessionDetailResponseModel?> getSessionDetailWithId(
      String sessionId) async {
    SessionDetailResponseModel? response;
    try {
      response = await _studentApi.getSessionWithId(sessionId);
    } on DioError catch (exception) {
      AppException.forException(exception.response);
    }
    return response;
  }

  Future<List<SessionDetailResponseModel>?> getSessionDetails(
      String studentId, String type) async {
    List<SessionDetailResponseModel>? listOfSessionDetails = [];
    try {
      listOfSessionDetails =
          await _studentApi.getSessionsByType(studentId, type);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfSessionDetails;
  }

  Future<List<TeacherDetailsModel>?> getTeacherDetailsWithTags(
      TagRequestModel addTagRequestModel) async {
    List<TeacherDetailsModel>? listOfTeacherDetails = [];
    try {
      listOfTeacherDetails =
          await _studentApi.getTeacherByTags(addTagRequestModel);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfTeacherDetails;
  }

  Future<StudentDetail?> uploadStudentProfileUrl(
      File file, String studentId) async {
    try {
      return await _studentApi.uploadStudentProleImage(file, studentId);
    } on DioError catch (exception) {
      AppException.forException(exception.response);
      return null;
    }
  }

  Future<void> saveSessionDetail(SessionSaveRequest sessionSaveRequest) async {
    try {
      await _studentApi.addSessionDetail(sessionSaveRequest);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }
}
