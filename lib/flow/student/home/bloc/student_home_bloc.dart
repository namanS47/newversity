import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/student/home/model/session_details.dart';

part 'student_home_events.dart';

part 'student_home_states.dart';

class StudentHomeBloc extends Bloc<StudentHomeEvents, StudentHomeStates> {

  List<SessionDetails> listOfSessionDetails = SessionDetails.listOdSessionDetails;

  int currentNextSessionIndex = 0;

  StudentHomeBloc() : super(StudentHomeInitialState()) {
    on<UpdatedNextSessionIndexEvent>((event, emit) async{
      updateNextSessionCarouselIndex(event,emit);
    });
  }

  void updateNextSessionCarouselIndex(event,emit){
    if(event is UpdatedNextSessionIndexEvent){
      currentNextSessionIndex = event.nextIndex;
      emit(UpdatedNextSessionIndexState());
    }
  }
}
