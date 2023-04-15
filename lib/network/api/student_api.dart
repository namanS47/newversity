import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/add_tag_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_detail_saving_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:retrofit/http.dart';

import '../../config/app_config.dart';
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

  @POST("/student")
  Future<StudentDetail?> saveStudentDetails(
      @Body() StudentDetailSavingRequestModel studentDetailSavingRequestModel,
      @Header("studentId") String studentId);

  @POST("/tags")
  Future<void> addListOfTags(@Body() AddTagRequestModel addTagRequestModel);

  @POST("/student/profileImage")
  @MultiPart()
  Future<StudentDetail?> uploadStudentProleImage(
      @Part() File file, @Part() String studentId);

  @GET("/tag/search")
  Future<List<String>> fetchTagsListBySearchKeyword(@Query("tag") String tag);
}
