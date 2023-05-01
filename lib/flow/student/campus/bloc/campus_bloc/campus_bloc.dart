import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'campus_event.dart';

part 'campus_states.dart';

class StudentCampusBloc extends Bloc<StudentCampusEvents, StudentCampusStates> {
  StudentCampusBloc() : super(StudentCampusInitialState()) {
    on<ShowCampusEvent>((event, emit) {});
  }
}
