part of 'booking_session_details_bloc.dart';

@immutable
abstract class BookingSessionDetailsEvents {}

class CancelRequestSelectEvent extends BookingSessionDetailsEvents {
  String item;
  CancelRequestSelectEvent({required this.item});
}

class FetchSessionDetailByIdEvent extends BookingSessionDetailsEvents {
  final String id;
  FetchSessionDetailByIdEvent({required this.id});
}

class SessionAddingEvent extends BookingSessionDetailsEvents {
  final SessionSaveRequest sessionSaveRequest;
  SessionAddingEvent({required this.sessionSaveRequest});
}

class FetchStudentDetailsEvent extends BookingSessionDetailsEvents {
  final String studentId;
  FetchStudentDetailsEvent({required this.studentId});
}
