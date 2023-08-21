part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class LoadingState extends AppInitial {}

class FetchingInitialRouteLoadingState extends AppInitial {}

class FetchingInitialRouteSuccessState extends AppInitial {
  FetchingInitialRouteSuccessState({required this.routeName});

  final String routeName;
}

class ShowAppUpdateDialogue extends AppInitial {
  ShowAppUpdateDialogue(
      {required this.mandatory,
      required this.availableVersion,
      required this.currentVersion});

  final String currentVersion;
  final String availableVersion;
  final bool mandatory;
}

class CheckingAppUpdateFlowComplete extends AppInitial {}

class RedirectToLoginRoute extends AppInitial {}

class RedirectToStudentHome extends AppInitial {}

class RedirectToStudentProfileDashboardRoute extends AppInitial {
  RedirectToStudentProfileDashboardRoute({required this.index});
  final int index;
}

class RedirectToTeacherPersonalInformationRoute extends AppInitial {}

class RedirectToTeacherHomeRoute extends AppInitial {}

class SomethingWentWrongState extends AppInitial {}
