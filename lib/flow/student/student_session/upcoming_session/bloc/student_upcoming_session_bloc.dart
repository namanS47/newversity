import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'student_upcoming_session_events.dart';

part 'student_upcoming_session_states.dart';

class StudentUpcomingSessionBloc
    extends Bloc<StudentUpcomingSessionEvents, StudentUpcomingSessionStates> {
  StudentUpcomingSessionBloc() : super(StudentUpcomingSessionInitialState()) {}
}
