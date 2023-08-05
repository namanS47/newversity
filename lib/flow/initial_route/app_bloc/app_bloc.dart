import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/initial_route/model/common_details_model.dart';
import 'package:newversity/network/api/common_api.dart';
import 'package:newversity/network/api/student_api.dart';
import 'package:newversity/network/webservice/exception.dart';
import 'package:newversity/storage/app_constants.dart';
import 'package:newversity/storage/preferences.dart';

import '../../../network/api/teacher_api.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final TeacherApi _teacherApi = DI.inject<TeacherApi>();
  final StudentApi _studentApi = DI.inject<StudentApi>();
  final CommonApi _commonApi = DI.inject<CommonApi>();

  AppBloc() : super(AppInitial()) {
    on<CheckForAppUpdateEvent>((event, emit) async {
      await checkForUpdateEvent(emit);
    });

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

    //TODO: Naman
    if (GlobalConstants.initialMessage != null) {
      print("naman--- initial fcm message ${GlobalConstants.initialMessage?.data}");
    }

    sendFcmToken();

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
      } on AppException {
        return emit(SomethingWentWrongState());
      }
    }

    final isTeacher = await CommonUtils().isUserTeacher();
    if (isTeacher) {
      final teacherId = CommonUtils().getLoggedInUser();
      try {
        final response = await _teacherApi.getProfileCompletionInfo(teacherId);
        if (response != null && response.completePercentage != 0) {
          return emit(RedirectToTeacherHomeRoute());
        } else {
          return emit(RedirectToTeacherPersonalInformationRoute());
        }
      } on AppException {
        return emit(SomethingWentWrongState());
      }
    }
  }

  Future<void> sendFcmToken() async {
    String fcmToken = await CommonUtils().getFcmToken();
    _commonApi.sendFcmToken(CommonDetailsModel(
      firebaseUserId: CommonUtils().getLoggedInUser(),
      fcmToken: fcmToken,
    ));
  }

  compareVersionForUpdate(String availableVersion, String currentVersion) {
    int currentVersionNumber = double.parse(currentVersion.trim().replaceAll(".", "")).toInt();
    int availableVersionNumber = double.parse(availableVersion.trim().replaceAll(".", "")).toInt();
    return currentVersionNumber < availableVersionNumber;
  }

  checkForUpdateEvent(Emitter<AppState> emit ) async {
    GlobalConstants.isCheckedForAppUpdate = true;
    final response = await _commonApi.fetchAppVersionDetails();
    if (response != null && response.version != null) {
      String version = response.version!;
      String appVersion = await CommonUtils().getAppVersion();
      if (compareVersionForUpdate(version, appVersion)) {
        return emit(ShowAppUpdateDialogue(
          mandatory: response.mandatory!,
            availableVersion: version,
            currentVersion: appVersion));
      } else {
        emit(CheckingAppUpdateFlowComplete());
      }
    } else {
      emit(CheckingAppUpdateFlowComplete());
    }
  }
}
