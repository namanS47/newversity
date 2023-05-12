import 'package:dio/dio.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/student/webservice/student_base_repository.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:newversity/network/api/student_api.dart';

import '../../../../network/webservice/exception.dart';

class SearchRepository extends StudentBaseRepository {
  final StudentApi _studentApi = DI.inject<StudentApi>();

  Future<List<String>?> fetchTagsListBySearchKeyword(String tag) async {
    try {
      return await _studentApi.fetchTagsListBySearchKeyword(tag);
    } on DioError catch (exception){
      throw AppException.forException(exception.response);
    }
  }

  Future<List<TeacherDetailsModel>?> fetchTeachersListByTagName(String searchKeyWord) async {
    try {
      return await _studentApi.fetchTeacherDetailsByTagName(searchKeyWord);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }
}