import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/teacher/bank_account/model/bank_request_model.dart';
import 'package:newversity/flow/teacher/bank_account/model/bank_response_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/flow/teacher/profile/model/education_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';
import 'package:newversity/flow/teacher/profile/model/tags_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:newversity/network/api/teacher_api.dart';
import 'package:newversity/network/webservice/exception.dart';

import '../../../network/webservice/base_repository.dart';
import '../../model/session_count_response_model.dart';
import '../../student/student_session/my_session/model/session_detail_response_model.dart';
import '../home/model/session_request_model.dart';
import '../home/model/session_response_model.dart';

class TeacherBaseRepository extends BaseRepository {
  final TeacherApi _teacherApi = DI.inject<TeacherApi>();

  Future<TeacherDetailsModel?> addTeacherDetails(
      TeacherDetailsModel teacherDetails, String teacherId) async {
    try {
      return await _teacherApi.sendTeacherDetails(teacherDetails, teacherId);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<BankResponseModel?> getBankDetails(String teacherId) async {
    try {
      return await _teacherApi.getBankAccount(teacherId);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> addBankAccount(
      String teacherId, AddBankRequestModel bankRequestModel) async {
    try {
      return await _teacherApi.addBankAccount(teacherId, bankRequestModel);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<List<SessionDetailResponseModel>?> getSessionDetails(
      String teacherId, String type) async {
    List<SessionDetailResponseModel>? listOfSessionDetails = [];
    try {
      listOfSessionDetails =
          await _teacherApi.getSessionDetails(teacherId, type);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfSessionDetails;
  }

  Future<void> saveSessionDetail(SessionSaveRequest sessionSaveRequest) async {
    try {
      await _teacherApi.addSessionDetail(sessionSaveRequest);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> saveTeachersExperience(
      ExperienceDetailsModel experienceRequestModel, String teacherId) async {
    try {
      await _teacherApi.saveTeacherExperience(
          experienceRequestModel, teacherId);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> saveTeachersEducation(
      EducationDetailsModel educationRequestModel, String teacherId) async {
    try {
      await _teacherApi.saveTeacherEducation(educationRequestModel);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }
  
  Future<void> deleteEducationDetails(String id) async {
    try{
      await _teacherApi.deleteTeacherEducationDetails(id);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> deleteExperienceDetails(String id) async {
    try{
      await _teacherApi.deleteTeacherExperienceDetails(id);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> saveListOfTags(
      String category, List<TagModel> listOfTags, String teacherId) async {
    try {
      await _teacherApi.saveListOfTags(
          category, TagRequestModel(tagModelList: listOfTags), teacherId);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<List<TagsResponseModel>?> fetchAllTags() async {
    List<TagsResponseModel>? listOfTags = [];
    try {
      listOfTags = await _teacherApi.getTags();
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfTags;
  }

  Future<List<TagsResponseModel>?> fetchAllTagsWithTeacherId(
      String teacherId) async {
    List<TagsResponseModel>? listOfTags = [];
    try {
      listOfTags = await _teacherApi.getAllTagsByTeacherId(teacherId);
    } on DioException catch (exception) {
      AppException.forException(exception.response);
    }
    return listOfTags;
  }

  Future<List<ExperienceDetailsModel>?> fetchAllExperiencesWithTeacherId(
      String teacherId) async {
    List<ExperienceDetailsModel>? listOfExperiences = [];
    try {
      listOfExperiences =
          await _teacherApi.getExperiencesWithTeacherId(teacherId);
      print("---- $listOfExperiences");
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfExperiences;
  }

  Future<List<EducationDetailsModel>?> fetchAllEducationWithTeacherId(
      String teacherId) async {
    List<EducationDetailsModel>? listOfEducation = [];
    try {
      listOfEducation = await _teacherApi.getEducationsWithTeacherId(teacherId);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfEducation;
  }

  Future<TeacherDetailsModel?> getTeachersDetail(String teacherId) async {
    TeacherDetailsModel? response = TeacherDetailsModel();
    try {
      response = await _teacherApi.getTeacherDetails(teacherId);
    } on DioException catch (exception) {
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
    } on DioException catch (exception) {
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
    } on DioException catch (exception) {
      AppException.forException(exception.response);
    }
    return sessionDetailsResponse;
  }

  Future<void> uploadTagDocument(
      File file, String teacherId, String tagName) async {
    try {
      await _teacherApi.uploadTagDocument(file, teacherId, tagName);
    } on DioException catch (exception) {
      AppException.forException(exception.response);
    }
  }

  Future<TeacherDetailsModel?> uploadTeacherProfileUrl(
      File file, String teacherId) async {
    try {
      return await _teacherApi.uploadProfilePicture(file, teacherId);
    } on DioException catch (exception) {
      AppException.forException(exception.response);
      return null;
    }
  }

  Future<SessionCountResponseModel> fetchTeacherSessionCount(String teacherId) async {
    try {
      return await _teacherApi.fetchTeacherSessionCount(teacherId);
    } on DioException catch (exception) {
      AppException.forException(exception.response);
    }
    return SessionCountResponseModel();
  }
}
