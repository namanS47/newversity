import 'package:dio/dio.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/profile/model/education_request_model.dart';
import 'package:newversity/flow/teacher/profile/model/education_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_request_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';
import 'package:newversity/flow/teacher/profile/model/tags_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:newversity/network/api/teacher_api.dart';
import 'package:newversity/network/webservice/exception.dart';

import '../../../network/webservice/base_repository.dart';
import '../home/model/session_request_model.dart';
import '../home/model/session_response_model.dart';

class TeacherBaseRepository extends BaseRepository {
  final TeacherApi _teacherApi = DI.inject<TeacherApi>();

  Future<TeacherDetails?> addTeacherDetails(
      TeacherDetails teacherDetails, String teacherId) async {
    try {
      return await _teacherApi.sendTeacherDetails(teacherDetails, teacherId);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return null;
  }

  Future<List<SessionDetailsResponse>?> getSessionDetails(
      String teacherId, String type) async {
    List<SessionDetailsResponse>? listOfSessionDetails = [];
    try {
      listOfSessionDetails =
          await _teacherApi.getSessionDetails(teacherId, type);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfSessionDetails;
  }

  Future<void> saveSessionDetail(SessionSaveRequest sessionSaveRequest) async {
    try {
      await _teacherApi.addSessionDetail(sessionSaveRequest);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> saveTeachersExperience(
      ExperienceRequestModel experienceRequestModel, String teacherId) async {
    try {
      await _teacherApi.saveTeacherExperience(
          experienceRequestModel, teacherId);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> saveTeachersEducation(
      EducationRequestModel educationRequestModel, String teacherId) async {
    try {
      await _teacherApi.saveTeacherEducation(educationRequestModel);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> saveListOfTags(
      String category, List<TagModel> listOfTags, String teacherId) async {
    try {
      await _teacherApi.saveListOfTags(
          category, TagRequestModel(tagModelList: listOfTags), teacherId);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<List<TagsResponseModel>?> fetchAllTags() async {
    List<TagsResponseModel>? listOfTags = [];
    try {
      listOfTags = await _teacherApi.getTags();
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfTags;
  }

  Future<List<TagsResponseModel>?> fetchAllTagsWithTeacherId(
      String teacherId) async {
    List<TagsResponseModel>? listOfTags = [];
    try {
      listOfTags = await _teacherApi.getAllTagsByTeacherId(teacherId);
    } on DioError catch (exception) {
      AppException.forException(exception.response);
    }
    return listOfTags;
  }

  Future<List<ExperienceResponseModel>?> fetchAllExperiencesWithTeacherId(
      String teacherId) async {
    List<ExperienceResponseModel>? listOfExperiences = [];
    try {
      listOfExperiences =
          await _teacherApi.getExperiencesWithTeacherId(teacherId);
      print("---- $listOfExperiences");
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfExperiences;
  }

  Future<List<EducationResponseModel>?> fetchAllEducationWithTeacherId(
      String teacherId) async {
    List<EducationResponseModel>? listOfEducation = [];
    try {
      listOfEducation = await _teacherApi.getEducationsWithTeacherId(teacherId);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfEducation;
  }

  Future<TeacherDetails?> getTeachersDetail(String teacherId) async {
    TeacherDetails? response = TeacherDetails();
    try {
      response = await _teacherApi.getTeacherDetails(teacherId);
    } on DioError catch (exception) {
      AppException.forException(exception.response);
    }
    return response;
  }

  Future<ProfileCompletionPercentageResponse?> getProfileCompletionInfo(
      String teacherId) async {
    ProfileCompletionPercentageResponse? response =
        ProfileCompletionPercentageResponse();
    try {
      response = await _teacherApi.getProfileCompletionInfo(teacherId);
    } on DioError catch (exception) {
      AppException.forException(exception.response);
    }
    return response;
  }

  Future<SessionDetailsResponse?> getSessionDetailsById(
      String sessionId) async {
    SessionDetailsResponse? sessionDetailsResponse = SessionDetailsResponse();
    try {
      sessionDetailsResponse =
          await _teacherApi.getSessionDetailById(sessionId);
    } on DioError catch (exception) {
      AppException.forException(exception.response);
    }
    return sessionDetailsResponse;
  }
}
