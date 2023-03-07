import 'package:dio/dio.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/network/api/teacher_api.dart';
import 'package:newversity/network/webservice/exception.dart';

import '../../../network/webservice/base_repository.dart';

class TeacherBaseRepository extends BaseRepository {
  final TeacherApi _teacherApi = DI.inject<TeacherApi>();

  Future<TeacherDetails?> addTeacherDetails(TeacherDetails teacherDetails, String teacherId) async {
    try{
      return await _teacherApi.sendTeacherDetails(teacherDetails, teacherId);
    } on DioError catch(exception) {
      AppException.forException(exception.response);
    }
    return null;
  }
}