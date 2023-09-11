import 'package:dio/dio.dart';
import 'package:newversity/flow/student/webservice/student_base_repository.dart';

import '../../../../di/di_initializer.dart';
import '../../../../network/api/student_api.dart';
import '../../../../network/webservice/exception.dart';
import 'model/webinar_details_response_model.dart';

class WebinarRepository extends StudentBaseRepository {
  final StudentApi _studentApi = DI.inject<StudentApi>();

  Future<List<WebinarDetailsResponseModel>> fetchWebinarList() async {
    try {
      return await _studentApi.fetchWebinarList();
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> registerForWebinar(
      String webinarId, StudentsInfoList studentDetails) async {
    try {
      await _studentApi.registerForWebinar(webinarId, studentDetails);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }
}
