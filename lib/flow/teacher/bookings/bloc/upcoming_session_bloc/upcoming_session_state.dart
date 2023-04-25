part of 'upcoming_session_bloc.dart';

@immutable
class UpcomingSessionStates {}

class UpcomingSessionInitialState extends UpcomingSessionStates {}

class UpdatedTimeRageIndexState extends UpcomingSessionStates {}

class UpdatedSortByIndexState extends UpcomingSessionStates {}

class FetchingUpcomingSessionState extends UpcomingSessionStates {}

class FetchedUpcomingSessionState extends UpcomingSessionStates {
  final List<SessionDetailResponseModel>? sessionDetailResponse;
  FetchedUpcomingSessionState({required this.sessionDetailResponse});
}

class FetchingUpcomingSessionFailureState extends UpcomingSessionStates {
  final String msg;
  FetchingUpcomingSessionFailureState({required this.msg});
}
