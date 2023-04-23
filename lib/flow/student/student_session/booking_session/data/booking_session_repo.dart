import 'package:dio/dio.dart';
import 'package:newversity/flow/student/webservice/student_base_repository.dart';

import '../../../../../di/di_initializer.dart';
import '../../../../../network/api/teacher_api.dart';
import '../../../../../network/webservice/exception.dart';
import '../../../../teacher/availability/data/model/availability_model.dart';
import '../../../../teacher/availability/data/model/fetch_availability_request_model.dart';
import '../../../../teacher/data/model/teacher_details/teacher_details.dart';
import '../../../../teacher/profile/model/education_response_model.dart';
import '../../../../teacher/profile/model/experience_response_model.dart';

class SessionBookingRepository extends StudentBaseRepository {
  final TeacherApi _teacherApi = DI.inject<TeacherApi>();

  Future<List<AvailabilityModel>?> fetchAvailability(
      FetchAvailabilityRequestModel request) async {
    try {
      return await _teacherApi.fetchAvailability(request);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<List<ExperienceResponseModel>?> fetchAllExperiencesWithTeacherId(
      String teacherId) async {
    List<ExperienceResponseModel>? listOfExperiences = [];
    try {
      listOfExperiences =
          await _teacherApi.getExperiencesWithTeacherId(teacherId);
      print("---- $listOfExperiences");
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfExperiences;
  }

  Future<List<EducationResponseModel>?> fetchAllEducationWithTeacherId(
      String teacherId) async {
    List<EducationResponseModel>? listOfEducation = [];
    try {
      listOfEducation = await _teacherApi.getEducationsWithTeacherId(teacherId);
    } on DioError catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfEducation;
  }

  Future<TeacherDetailsModel?> getTeachersDetail(String teacherId) async {
    TeacherDetailsModel? response;
    try {
      response = await _teacherApi.getTeacherDetails(teacherId);
    } on DioError catch (exception) {
      AppException.forException(exception.response);
    }
    return response;
  }
}
