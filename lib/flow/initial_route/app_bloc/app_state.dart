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

class RedirectToLoginRoute extends AppInitial {}

class RedirectToStudentHome extends AppInitial {}

class RedirectToStudentProfileDashboardRoute extends AppInitial {}

class RedirectToTeacherPersonalInformationRoute extends AppInitial {}

class RedirectToTeacherHomeRoute extends AppInitial {}

class SomethingWentWrongState extends AppInitial {}
