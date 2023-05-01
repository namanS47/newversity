import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';

import '../../../../../storage/preferences.dart';
import '../../../webservice/teacher_base_repository.dart';

part 'teacher_details_event.dart';
part 'teacher_details_state.dart';

class TeacherDetailsBloc extends Bloc<TeacherDetailsEvent, TeacherDetailsState> {
  final TeacherBaseRepository _teacherBaseRepository = DI.inject<TeacherBaseRepository>();
  String teacherId = CommonUtils().getLoggedInUser();
  TeacherDetailsModel? teacherDetails;

  TeacherDetailsBloc() : super(TeacherDetailsInitial()) {
    on<SaveTeacherDetailsEvent>((event, emit) async {
      emit(TeacherDetailsSavingState());
      event.teacherDetails.mobileNumber = await DI.inject<Preferences>().getMobileNumber();
      final response = await _teacherBaseRepository.addTeacherDetails(event.teacherDetails, teacherId);
      if(response != null) {
        emit(TeacherDetailsSavingSuccessState());
      } else {
        emit(TeacherDetailsSavingFailureState());
      }
    });

    on<UploadTeacherImageEvent>((event, emit) async {
      emit(TeacherImageUploadLoadingState());
      try{
        File newFile = CommonUtils().renameFile(event.file, teacherId);
        await _teacherBaseRepository.uploadTeacherProfileUrl(newFile, teacherId);
        newFile.delete();
        emit(TeacherImageUploadSuccessState());
      } catch(exception) {
        emit(TeacherImageUploadFailureState());
      }
    });

    on<FetchTeacherDetailEvent>((event, emit) async {
      emit(FetchTeacherDetailLoadingState());
      try{
        teacherDetails =
        await _teacherBaseRepository.getTeachersDetail(teacherId);
        emit(FetchTeacherDetailSuccessState());
      } catch (exception) {
        emit(FetchTeacherDetailFailureState());
      }
    });
  }
}
