import 'package:dio/dio.dart';
import 'package:newversity/flow/teacher/availability/data/model/fetch_availability_request_model.dart';
import 'package:newversity/flow/teacher/webservice/teacher_base_repository.dart';

import '../../../../../di/di_initializer.dart';
import '../../../../../network/api/teacher_api.dart';
import '../../../../../network/webservice/exception.dart';
import '../model/add_availability_request_model.dart';
import '../model/availability_model.dart';

class AvailabilityRepository extends TeacherBaseRepository {
  final TeacherApi _teacherApi = DI.inject<TeacherApi>();
  Future<void> saveAvailability(AddAvailabilityRequestModel availabilityRequestModel) async {
    try{
       final response = await _teacherApi.addAvailabilities(availabilityRequestModel);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<List<AvailabilityModel>?> fetchAvailability(FetchAvailabilityRequestModel request) async {
    try{
      return await _teacherApi.fetchAvailability(request);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> removeAvailability(String id) async {
    try{
      await _teacherApi.removeAvailability(id);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }
}