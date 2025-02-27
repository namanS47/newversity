import 'package:dio/dio.dart';
import 'package:newversity/flow/student/webservice/student_base_repository.dart';
import 'package:newversity/network/api/student_api.dart';

import '../../../../../di/di_initializer.dart';
import '../../../../../network/api/teacher_api.dart';
import '../../../../../network/webservice/exception.dart';
import '../../../../teacher/availability/data/model/availability_model.dart';
import '../../../../teacher/availability/data/model/fetch_availability_request_model.dart';
import '../../../../teacher/data/model/teacher_details/teacher_details_model.dart';
import '../../../../teacher/profile/model/education_response_model.dart';
import '../../../../teacher/profile/model/experience_response_model.dart';
import '../model/promo_code_details_response_model.dart';
import '../model/request_session_request_model.dart';

class SessionBookingRepository extends StudentBaseRepository {
  final TeacherApi _teacherApi = DI.inject<TeacherApi>();
  final StudentApi _studentApi = DI.inject<StudentApi>();

  Future<List<AvailabilityModel>?> fetchAvailability(
      FetchAvailabilityRequestModel request) async {
    try {
      return await _teacherApi.fetchAvailability(request.teacherId!, request.date);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<List<ExperienceDetailsModel>?> fetchAllExperiencesWithTeacherId(
      String teacherId) async {
    List<ExperienceDetailsModel>? listOfExperiences = [];
    try {
      listOfExperiences =
          await _teacherApi.getExperiencesWithTeacherId(teacherId);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfExperiences;
  }

  Future<List<EducationDetailsModel>?> fetchAllEducationWithTeacherId(
      String teacherId) async {
    List<EducationDetailsModel>? listOfEducation = [];
    try {
      listOfEducation = await _teacherApi.getEducationsWithTeacherId(teacherId);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
    return listOfEducation;
  }

  Future<TeacherDetailsModel?> getTeachersDetail(String teacherId) async {
    TeacherDetailsModel? response;
    try {
      response = await _teacherApi.getTeacherDetails(teacherId);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
    return response;
  }

  Future<PromoCodeDetailsResponseModel?> fetchPromoCodeDetails(String promoCode) async {
    try{
      final response = await _studentApi.fetchPromoCodeDetails(promoCode);
      return response;
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }

  Future<void> raiseSessionRequest(RequestSessionRequestModel request) async {
    try{
      await _studentApi.raiseSessionRequest(request);
    } on DioException catch (exception) {
      throw AppException.forException(exception.response);
    }
  }
}
