import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'student_session_events.dart';

part 'student_session_states.dart';

class StudentSessionBloc
    extends Bloc<StudentSessionEvents, StudentSessionStates> {
  StudentSessionBloc() : super(StudentSessionInitialState()) {
    on<UpdateTabBarEvent>((event, emit) {});
  }
}
