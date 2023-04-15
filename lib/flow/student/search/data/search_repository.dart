import 'package:dio/dio.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/network/api/student_api.dart';

import '../../../../network/webservice/exception.dart';

class SearchRepository {
  final StudentApi _studentApi = DI.inject<StudentApi>();

  Future<List<String>?> fetchTagsListBySearchKeyword(String tag) async {
    try {
      return await _studentApi.fetchTagsListBySearchKeyword(tag);
    } on DioError catch (exception){
      throw AppException.forException(exception.response);
    }
  }


}