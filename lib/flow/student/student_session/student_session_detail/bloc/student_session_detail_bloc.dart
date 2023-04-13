import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'student_session_deatil_states.dart';

part 'student_session_detail_events.dart';

class StudentSessionDetailBloc
    extends Bloc<StudentSessionDetailEvents, StudentSessionDetailStates> {




  StudentSessionDetailBloc() : super(StudentSessionDetailInitialState()) {}
}
