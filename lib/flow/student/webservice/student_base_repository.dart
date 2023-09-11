import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/add_tag_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_detail_saving_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/student/student_session/my_session/model/session_detail_response_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:newversity/network/api/student_api.dart';
import 'package:newversity/network/webservice/base_repository.dart';
import 'package:newversity/storage/preferences.dart';

import '../../../di/di_initializer.dart';
import '../../../network/webservice/exception.dart';
import '../../teacher/home/model/session_request_model.dart';
import '../../teacher/profile/model/profile_completion_percentage_response.dart';
import '../campus/data/pensil_token_request_model.dart';
import '../campus/data/pensil_token_response_model.dart';

class StudentBaseRepository extends BaseRepository {
  final StudentApi _studentApi = DI.inject<StudentApi>();

  Future<StudentDetail?> saveStudentDetails(
      StudentDetailSavingRequestModel studentDetailSavingRequestModel,
      String studentId) async {
    try {
      return await _studentApi.saveStudentDetails(
          studentDetailSavingRequestModel, studentId);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> addTags(AddTagRequestModel addTagRequestModel) async {
    try {
      return await _studentApi.addListOfTags(addTagRequestModel);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<StudentDetail?> fetchStudentDetails(String studentId) async {
    try {
      final response = await _studentApi.getStudentDetails(studentId);
      if (response != null) {
        DI.inject<Preferences>().setStudentDetails(response);
      }
      return response;
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<ProfileCompletionPercentageResponse?> getProfileCompletionInfo(
      String studentId) async {
    ProfileCompletionPercentageResponse? response =
        ProfileCompletionPercentageResponse();
    try {
      response = await _studentApi.getProfileCompletionInfo(studentId);
    } on DioException catch (exception) {
      AppException.forException(exception.response);
    }
    return response;
  }

  Future<SessionDetailResponseModel?> getSessionDetailWithId(
      String sessionId) async {
    SessionDetailResponseModel? response;
    try {
      response = await _studentApi.getSessionWithId(sessionId);
    } on DioException catch (exception) {
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
    } on DioException catch (exception) {
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
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfTeacherDetails;
  }

  Future<StudentDetail?> uploadStudentProfileUrl(
      File file, String studentId) async {
    try {
      return await _studentApi.uploadStudentProleImage(file, studentId);
    } on DioException catch (exception) {
      AppException.forException(exception.response);
      return null;
    }
  }

  Future<void> saveSessionDetail(SessionSaveRequest sessionSaveRequest) async {
    try {
      await _studentApi.addSessionDetail(sessionSaveRequest);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<PensilTokenResponseModel?> fetchCommunityUserToken(
      PensilTokenRequestModel pensilRequest) async {
    final dio = Dio();
    final data = <String, dynamic>{};
    final headers = <String, dynamic>{};
    data.addAll(pensilRequest.toJson());
    headers.addAll({
      "CLIENTID": "64755db87987ad1b2f0011c3.8aa1ef9afbb2e0799af4c96103a078e1",
      "CLIENTSECRET":
          "64755db87987ad1b2f0011c3.1001327c9b9ba487862c3a615067f055",
      "COMMUNITYID": "64755db87987ad1b2f0011c3"
    });
    final result = await dio.fetch<Map<String, dynamic>?>(
      _setStreamType<TeacherDetailsModel>(
        Options(
          method: 'POST',
          headers: headers,
        ).compose(
          dio.options,
          'https://api.pensil.in/api/3pc/generate-user-token',
          data: data,
        ),
      ),
    );
    return result.data != null ? PensilTokenResponseModel.fromJson(result.data!) : null;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
