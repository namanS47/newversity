
part of 'campus_bloc.dart';

@immutable
abstract class StudentCampusStates {}

class StudentCampusInitialState extends StudentCampusStates {}

class FetchUserCommunityTokenLoadingState extends StudentCampusStates {}

class FetchUserCommunityTokenSuccessState extends StudentCampusStates {
  FetchUserCommunityTokenSuccessState({required this.pensilResponse});
  final PensilTokenResponseModel pensilResponse;
}

class FetchUserCommunityTokenFailureState extends StudentCampusStates {}