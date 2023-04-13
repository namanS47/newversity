import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'student_previous_session_events.dart';

part 'student_previous_session_states.dart';

class StudentPreviousSessionBloc
    extends Bloc<StudentPreviousSessionEvents, StudentPreviousSessionState> {
  StudentPreviousSessionBloc() : super(StudentPreviousSessionInitialState()) {}
}
