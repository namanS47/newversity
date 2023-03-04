

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
part 'student_api.g.dart';

@RestApi(baseUrl: "http://localhost:8080/" "/student/")
abstract class StudentApi {
  factory StudentApi(Dio dio, {String? baseUrl}) {
    return _StudentApi(
        dio,
        baseUrl: baseUrl ?? ""
    );
  }
}