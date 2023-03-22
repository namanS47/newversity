import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';

import '../../../../../storage/preferences.dart';
import '../../../webservice/teacher_base_repository.dart';

part 'teacher_details_event.dart';
part 'teacher_details_state.dart';

class TeacherDetailsBloc extends Bloc<TeacherDetailsEvent, TeacherDetailsState> {
  TeacherBaseRepository _teacherBaseRepository = DI.inject<TeacherBaseRepository>();
  String teacherId = "";

  TeacherDetailsBloc() : super(TeacherDetailsInitial()) {
    on<SaveTeacherDetailsEvent>((event, emit) async {
      emit(TeacherDetailsSavingState());
      teacherId = CommonUtils().getLoggedInUser();
      event.teacherDetails.mobileNumber = await DI.inject<Preferences>().getMobileNumber();
      final response = await _teacherBaseRepository.addTeacherDetails(event.teacherDetails, teacherId);
      if(response != null) {
        emit(TeacherDetailsSavingSuccessState());
      } else {
        emit(TeacherDetailsSavingFailureState());
      }
    });
  }
}
