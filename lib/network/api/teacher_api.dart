import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../ui/teacher/model/teacher_details/teacher_details.dart';
part 'teacher_api.g.dart';

@RestApi(baseUrl: "http://localhost:8080/" "/teacher/")
abstract class TeacherApi {
  factory TeacherApi(Dio dio, {String? baseUrl}) {
    return _TeacherApi(
        dio,
        baseUrl: baseUrl ?? "/"
    );
  }
  
  @GET("/getTeacher")
  Future<TeacherDetails> getTeacherDetails(
      @Path("teacherId") String teacherId
      );

  @POST("/addTeacher")
  Future<TeacherDetails> sendTeacherDetails(
      @Body() TeacherDetails teacherDetails
      );
}