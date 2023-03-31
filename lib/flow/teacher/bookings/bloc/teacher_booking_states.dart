part of 'teacher_bookings_bloc.dart';

@immutable
abstract class TeacherBookingStates {}

class TeacherBookingInitial extends TeacherBookingStates {}

class UpdatedSessionState extends TeacherBookingStates {}
