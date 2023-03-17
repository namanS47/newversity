import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/storage/preferences.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<FetchInitialRouteEvent>((event, emit) async {
      emit(FetchingInitialRouteLoadingState());

    });
  }

  Future<String> fetchInitialRoute() async {
    if(!CommonUtils().isUserLoggedIn()) {
      DI.inject<Preferences>().resetFlow();
      return AppRoutes.loginRoute;
    }

    final isStudent = await CommonUtils().isUserStudent();
    if(isStudent) {
      return AppRoutes.homeScreen;
    }

    final isTeacher = await CommonUtils().isUserTeacher();
    if(isTeacher) {
      return AppRoutes.homeScreen;
    }

    return AppRoutes.homeScreen;
  }

  // Future<String> getRouteForTeacher() async {
  //
  // }
}
