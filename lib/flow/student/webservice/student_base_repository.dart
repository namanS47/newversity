import 'package:dio/dio.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/add_tag_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_detail_saving_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/network/api/student_api.dart';
import 'package:newversity/network/webservice/base_repository.dart';

import '../../../di/di_initializer.dart';
import '../../../network/webservice/exception.dart';

class StudentBaseRepository extends BaseRepository {
  final StudentApi _studentApi = DI.inject<StudentApi>();

  Future<StudentDetail?> saveStudentDetails(
      StudentDetailSavingRequestModel studentDetailSavingRequestModel,
      String studentId) async {
    try {
      return await _studentApi.saveStudentDetails(
          studentDetailSavingRequestModel, studentId);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> addTags(
      AddTagRequestModel addTagRequestModel) async {
    try {
      return await _studentApi.addListOfTags(
          addTagRequestModel);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<StudentDetail?> fetchStudentDetails(String studentId) async {
    try {
      return await _studentApi.getStudentDetails(studentId);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }
}
