part of 'session_details_bloc.dart';

@immutable
abstract class SessionDetailsStates {}

class SessionDetailsInitial extends SessionDetailsStates {}

class FetchingCancelReasonState extends SessionDetailsStates {}

class FetchedCancelReasonState extends SessionDetailsStates {}

class FetchingCancelReasonFailure extends SessionDetailsStates {}

class CancelRequestSelectedState extends SessionDetailsStates {}
