part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class FetchInitialRouteEvent extends AppEvent {}

class CheckForAppUpdateEvent extends AppEvent {}
