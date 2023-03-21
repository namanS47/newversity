import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/network/webservice/exception.dart';
import 'package:newversity/storage/preferences.dart';
import 'package:newversity/utils/string_extensions.dart';

import '../../../network/api/teacher_api.dart';
import '../../teacher/data/model/teacher_details/teacher_details.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final TeacherApi _teacherApi = DI.inject<TeacherApi>();

  AppBloc() : super(AppInitial()) {
    on<FetchInitialRouteEvent>((event, emit) async {
      emit(FetchingInitialRouteLoadingState());
      await fetchInitialRoute(emit);
    });
  }

  fetchInitialRoute(Emitter<AppState> emit) async {
    if (!CommonUtils().isUserLoggedIn()) {
      DI.inject<Preferences>().resetFlow();
      return emit(RedirectToLoginRoute());
    }

    final isStudent = await CommonUtils().isUserStudent();
    if (isStudent) {
      return emit(RedirectToStudentHome());
    }

    final isTeacher = await CommonUtils().isUserTeacher();
    if (isTeacher) {
      final teacherId = CommonUtils().getLoggedInUser();
      try {
        final response = await _teacherApi.getTeacherDetails(teacherId);
        if (response != null) {
          return emit(RedirectToTeacherHomeRoute());
        } else {
          return emit(RedirectToTeacherPersonalInformationRoute());
        }
      } on AppException catch (e) {
        return emit(SomethingWentWrongState());
      }
    }
  }

}

// String getTeacherRoute(TeacherDetails teacherDetails) {
//   bool redirectToPersonalInformationPage = !(teacherDetails.name.isValid &&
//       teacherDetails.profilePictureUrl.isValid &&
//       teacherDetails.info.isValid &&
//       teacherDetails.location.isValid);
//
//   bool redirectToExperienceAndQualificationPage = !(teacherDetails.title.isValid && teacherDetails.);
//
//   if (redirectToPersonalInformationPage) {
//
//   }
// }
