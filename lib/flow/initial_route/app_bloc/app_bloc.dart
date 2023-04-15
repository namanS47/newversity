import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/network/api/student_api.dart';
import 'package:newversity/network/webservice/exception.dart';
import 'package:newversity/storage/preferences.dart';

import '../../../network/api/teacher_api.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final TeacherApi _teacherApi = DI.inject<TeacherApi>();
  final StudentApi _studentApi = DI.inject<StudentApi>();

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
      final studentId = CommonUtils().getLoggedInUser();
      try {
        final response = await _studentApi.getProfileCompletionInfo(studentId);
        if (response != null && response.completePercentage != 0) {
          return emit(RedirectToStudentHome());
        } else {
          return emit(RedirectToStudentProfileDashboardRoute());
        }
      } on AppException catch (e) {
        return emit(SomethingWentWrongState());
      }
    }

    final isTeacher = await CommonUtils().isUserTeacher();
    if (isTeacher) {
      final teacherId = CommonUtils().getLoggedInUser();
      try {
        final response = await _teacherApi.getProfileCompletionInfo(teacherId);
        if (response != null && response.completePercentage == 100) {
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
