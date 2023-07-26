import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newversity/config/app_config.dart';
import 'package:newversity/flow/teacher/availability/data/model/availability_model.dart';
import 'package:newversity/flow/teacher/bank_account/model/bank_request_model.dart';
import 'package:newversity/flow/teacher/bank_account/model/bank_response_model.dart';
import 'package:newversity/flow/teacher/home/model/session_request_model.dart';
import 'package:newversity/flow/teacher/home/model/session_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/education_request_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_request_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';
import 'package:newversity/flow/teacher/profile/model/tags_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:retrofit/http.dart';

import '../../flow/model/session_count_response_model.dart';
import '../../flow/student/student_session/my_session/model/session_detail_response_model.dart';
import '../../flow/teacher/availability/data/model/add_availability_request_model.dart';
import '../../flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import '../../flow/teacher/profile/model/education_response_model.dart';

part 'teacher_api.g.dart';

@RestApi(baseUrl: EnvironmentValues.newversityStagingUrl)
abstract class TeacherApi {
  factory TeacherApi(Dio dio, {String? baseUrl}) {
    return _TeacherApi(dio,
        baseUrl: baseUrl ?? AppConfig.instance.config.newversityAPIBaseUrl);
  }

  @GET("/teacher")
  @NoBody()
  Future<TeacherDetailsModel?> getTeacherDetails(
      @Header("teacherId") String teacherId);

  @GET("/session/id")
  @NoBody()
  Future<SessionDetailsResponse?> getSessionDetailById(
      @Header("id") String sessionId);

  @POST("/addTeacher")
  Future<TeacherDetailsModel?> sendTeacherDetails(
      @Body() TeacherDetailsModel teacherDetails,
      @Header("teacherId") String teacherId);

  @POST("/teacher/experience")
  Future<void> saveTeacherExperience(
      @Body() ExperienceRequestModel experienceRequestModel,
      @Header("teacherId") String teacherId);

  @GET("/tags")
  @NoBody()
  Future<List<TagsResponseModel>?> getTags();

  @GET("/teacher/tags")
  @NoBody()
  Future<List<TagsResponseModel>?> getAllTagsByTeacherId(
      @Header("teacherId") String teacherId);

  @GET("/teacher/experience")
  @NoBody()
  Future<List<ExperienceResponseModel>?> getExperiencesWithTeacherId(
      @Header("teacherId") String teacherId);

  @GET("/teacher/completion")
  @NoBody()
  Future<ProfileCompletionPercentageResponse?> getProfileCompletionInfo(
      @Header("teacherId") String teacherId);

  @POST("/teacher/education")
  Future<void> saveTeacherEducation(
    @Body() EducationRequestModel educationRequestModel,
  );

  @POST("/teacher/tags")
  Future<void> saveListOfTags(@Query("category") String category,
      @Body() TagRequestModel tagsList, @Header("teacherId") String teacherId);

  @GET("/teacher/education")
  @NoBody()
  Future<List<EducationResponseModel>?> getEducationsWithTeacherId(
      @Header("teacherId") String teacherId);

  @POST("/teacher/availability")
  Future<void>? addAvailabilities(
      @Body() AddAvailabilityRequestModel availabilityRequestModel);

  @POST("/session/add")
  Future<void>? addSessionDetail(@Body() SessionSaveRequest sessionSaveRequest);

  @POST("/bankAccount")
  Future<void> addBankAccount(@Header("teacherId") String teacherId,
      @Body() AddBankRequestModel addBankRequestModel);

  @GET("/bankAccount")
  @NoBody()
  Future<BankResponseModel?>? getBankAccount(
      @Header("teacherId") String teacherId);

  @GET("/teacher/availability")
  @NoBody()
  Future<List<AvailabilityModel>?> fetchAvailability(
      @Header("teacherId") String teacherId,
      @Header("date") DateTime? date
  );

  @DELETE("/teacher/availability")
  Future<void> removeAvailability(@Header("id") String id);

  @GET("/session/teacher")
  @NoBody()
  Future<List<SessionDetailResponseModel>?> getSessionDetails(
      @Header("teacherId") String teacherId, @Query("type") String type);

  @POST("/teacher/tags/verify")
  @MultiPart()
  Future<void> uploadTagDocument(
      @Part() File file, @Part() String teacherId, @Part() String tag);

  @POST("/teacher/profileImage")
  @MultiPart()
  Future<TeacherDetailsModel?> uploadProfilePicture(
      @Part() File file, @Part() String teacherId);

  @GET("/session/count")
  Future<SessionCountResponseModel> fetchTeacherSessionCount(@Query("teacherId") String teacherId);
}
