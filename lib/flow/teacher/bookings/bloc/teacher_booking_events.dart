part of 'teacher_bookings_bloc.dart';

@immutable
abstract class TeacherBookingEvent {}

class ChangeSessionTabEvent extends TeacherBookingEvent {
  final int index;
  ChangeSessionTabEvent({required this.index});
}
