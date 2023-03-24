import 'package:dio/dio.dart';
import 'package:newversity/config/app_config.dart';
import 'package:newversity/flow/teacher/profile/model/education_request_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_request_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/tags_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:retrofit/http.dart';

import '../../flow/teacher/data/model/teacher_details/teacher_details.dart';
import '../../flow/teacher/profile/model/education_response_model.dart';

part 'teacher_api.g.dart';

@RestApi(baseUrl: EnvironmentValues.newversityStagingUrl)
abstract class TeacherApi {
  factory TeacherApi(Dio dio, {String? baseUrl}) {
    return _TeacherApi(dio,
        baseUrl: baseUrl ?? AppConfig.instance.config.newversityAPIBaseUrl);
  }

  @GET("/teacher")
  Future<TeacherDetails?> getTeacherDetails(
      @Header("teacherId") String teacherId);

  @POST("/addTeacher")
  Future<TeacherDetails?> sendTeacherDetails(
      @Body() TeacherDetails teacherDetails,
      @Header("teacherId") String teacherId);

  @POST("/teacher/experience")
  Future<void> saveTeacherExperience(
      @Body() ExperienceRequestModel experienceRequestModel,
      @Header("teacherId") String teacherId);
  
  @GET("/tags")
  Future<List<TagsResponseModel>?> getTags();

  @GET("/teacher/experience")
  Future<List<ExperienceResponseModel>?> getExperiencesWithTeacherId(
      @Header("teacherId") String teacherId
      );

  @POST("/teacher/education")
  Future<void> saveTeacherEducation(
      @Body() EducationRequestModel educationRequestModel,
      );
  @POST("/teacher/tags")
  Future<void> saveListOfTags(
      @Body() List<TagsWithTeacherIdRequestModel> lisOfTags,
      @Header("teacherId") String teacherId
      );

  @GET("/teacher/education")
  Future<List<EducationResponseModel>?> getEducationsWithTeacherId(
      @Header("teacherId") String teacherId
      );
}
