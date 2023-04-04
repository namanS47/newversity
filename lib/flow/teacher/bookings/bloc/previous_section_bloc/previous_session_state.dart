part of 'previous_session_bloc.dart';

@immutable
abstract class PreviousSessionStates {}

class PreviousSessionInitialState extends PreviousSessionStates {}

class UpdatedTimeRageIndexState extends PreviousSessionStates {}

class UpdatedSortByIndexState extends PreviousSessionStates {}

class FetchingPreviousSessionState extends PreviousSessionStates {}

class FetchedPreviousSessionState extends PreviousSessionStates {
  final List<SessionDetailsResponse>? listOfPreviousSession;
  FetchedPreviousSessionState({required this.listOfPreviousSession});
}

class FetchingPreviousSessionFailureState extends PreviousSessionStates {
  final String msg;
  FetchingPreviousSessionFailureState({required this.msg});
}
