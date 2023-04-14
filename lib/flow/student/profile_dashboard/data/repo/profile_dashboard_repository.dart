import 'package:dio/dio.dart';
import 'package:newversity/flow/student/webservice/student_base_repository.dart';

import '../../../../../di/di_initializer.dart';
import '../../../../../network/api/student_api.dart';
import '../../../../../network/webservice/exception.dart';
import '../../../../teacher/profile/model/tags_response_model.dart';

class ProfileDashboardRepository extends StudentBaseRepository {
  final StudentApi _studApi = DI.inject<StudentApi>();

  Future<List<TagsResponseModel>?> fetchAllTags() async {
    List<TagsResponseModel>? listOfTags = [];
    try {
      listOfTags = await _studApi.getTags();
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfTags;
  }
}
