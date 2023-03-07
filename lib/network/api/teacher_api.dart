import 'package:dio/dio.dart';
import 'package:newversity/config/app_config.dart';
import 'package:retrofit/http.dart';

import '../../flow/teacher/data/model/teacher_details/teacher_details.dart';
part 'teacher_api.g.dart';

@RestApi(baseUrl: EnvironmentValues.newversityStagingUrl)
abstract class TeacherApi {
  factory TeacherApi(Dio dio, {String? baseUrl}) {
    return _TeacherApi(
        dio,
        baseUrl: baseUrl ?? AppConfig.instance.config.newversityAPIBaseUrl
    );
  }
  
  @GET("/getTeacher")
  Future<TeacherDetails> getTeacherDetails(
      @Path("teacherId") String teacherId
      );

  @POST("/addTeacher")
  Future<TeacherDetails> sendTeacherDetails(
      @Body() TeacherDetails teacherDetails,
      @Header("teacherId") String teacherId
      );
}