import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/add_tag_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_detail_saving_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/student/student_session/my_session/model/session_detail_response_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:retrofit/http.dart';

import '../../config/app_config.dart';
import '../../flow/teacher/home/model/session_request_model.dart';
import '../../flow/teacher/profile/model/profile_completion_percentage_response.dart';
import '../../flow/teacher/profile/model/tags_response_model.dart';

part 'student_api.g.dart';

@RestApi(baseUrl: EnvironmentValues.newversityStagingUrl)
abstract class StudentApi {
  factory StudentApi(Dio dio, {String? baseUrl}) {
    return _StudentApi(dio,
        baseUrl: baseUrl ?? AppConfig.instance.config.newversityAPIBaseUrl);
  }

  @GET("/student")
  Future<StudentDetail?> getStudentDetails(
      @Header("studentId") String studentId);

  @GET("/tags")
  Future<List<TagsResponseModel>?> getTags();

  @GET("/session/student")
  Future<List<SessionDetailResponseModel>?> getSessionsByType(
      @Header("studentId") String studentId, @Query("type") String type);

  @POST("/student")
  Future<StudentDetail?> saveStudentDetails(
      @Body() StudentDetailSavingRequestModel studentDetailSavingRequestModel,
      @Header("studentId") String studentId);

  @GET("/session/id")
  Future<SessionDetailResponseModel?> getSessionWithId(
      @Header("id") String sessionId);

  @POST("/session/add")
  Future<void>? addSessionDetail(@Body() SessionSaveRequest sessionSaveRequest);

  @GET("/student/completion")
  Future<ProfileCompletionPercentageResponse?> getProfileCompletionInfo(
      @Header("studentId") String studentId);

  @POST("/tags")
  Future<void> addListOfTags(@Body() AddTagRequestModel addTagRequestModel);

  @GET("/tag/allTeacher")
  Future<List<TeacherDetails>?> getTeacherByTags(
      @Body() TagRequestModel addTagRequestModel);

  @POST("/student/profileImage")
  @MultiPart()
  Future<StudentDetail?> uploadStudentProleImage(
      @Part() File file, @Part() String studentId);
}
