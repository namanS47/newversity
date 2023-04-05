part of 'session_details_bloc.dart';

@immutable
abstract class SessionDetailsStates {}

class SessionDetailsInitial extends SessionDetailsStates {}

class FetchingCancelReasonState extends SessionDetailsStates {}

class FetchedCancelReasonState extends SessionDetailsStates {}

class FetchingCancelReasonFailure extends SessionDetailsStates {}

class CancelRequestSelectedState extends SessionDetailsStates {}

class FetchingSessionDetailByIdState extends SessionDetailsStates {}

class FetchedSessionDetailByIdState extends SessionDetailsStates {
  final SessionDetailsResponse? sessionDetails;
  FetchedSessionDetailByIdState({required this.sessionDetails});
}

class FetchingSessionDetailByIdFailureState extends SessionDetailsStates {
  final String msg;
  FetchingSessionDetailByIdFailureState({required this.msg});
}

class SavingSessionDetailState extends SessionDetailsStates {}

class SavedSessionDetails extends SessionDetailsStates {}

class SavingSessionDetailFailureState extends SessionDetailsStates {
  final String message;
  SavingSessionDetailFailureState({required this.message});
}
