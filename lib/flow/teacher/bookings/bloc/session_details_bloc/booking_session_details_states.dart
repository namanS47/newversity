part of 'booking_session_details_bloc.dart';

@immutable
abstract class BookingSessionDetailsStates {}

class SessionDetailsInitial extends BookingSessionDetailsStates {}

class FetchingCancelReasonState extends BookingSessionDetailsStates {}

class FetchedCancelReasonState extends BookingSessionDetailsStates {}

class FetchingCancelReasonFailure extends BookingSessionDetailsStates {}

class CancelRequestSelectedState extends BookingSessionDetailsStates {}

class FetchingSessionDetailByIdState extends BookingSessionDetailsStates {}

class FetchedSessionDetailByIdState extends BookingSessionDetailsStates {
  final SessionDetailsResponse? sessionDetails;
  FetchedSessionDetailByIdState({required this.sessionDetails});
}

class FetchingSessionDetailByIdFailureState extends BookingSessionDetailsStates {
  final String msg;
  FetchingSessionDetailByIdFailureState({required this.msg});
}

class SavingSessionDetailState extends BookingSessionDetailsStates {}

class SavedSessionDetails extends BookingSessionDetailsStates {}

class SavingSessionDetailFailureState extends BookingSessionDetailsStates {
  final String message;
  SavingSessionDetailFailureState({required this.message});
}

class FetchingStudentDetailsState extends BookingSessionDetailsStates {}

class FetchedStudentDetailsState extends BookingSessionDetailsStates {
  final StudentDetail? studentDetail;
  FetchedStudentDetailsState({required this.studentDetail});
}

class FetchingStudentDetailsFailureState extends BookingSessionDetailsStates {
  final String message;
  FetchingStudentDetailsFailureState({required this.message});
}
