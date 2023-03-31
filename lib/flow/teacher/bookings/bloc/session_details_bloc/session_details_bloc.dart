import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'session_details_event.dart';

part 'session_details_states.dart';

class SessionDetailsBloc
    extends Bloc<SessionDetailsEvents, SessionDetailsStates> {
  List<String> listOfCancelRequest = [
    "Language Problem",
    "Not able to understand concept",
    "Mentor is not comfortable",
    "Network problem",
    "Online is not suiting me",
    "Others"
  ];

  List<String> selectedCancelRequest = [];

  SessionDetailsBloc() : super(SessionDetailsInitial()) {
    on<CancelRequestSelectEvent>((event, emit) async {
      updateSelectedRequest(event, emit);
    });
  }

  Future<void> updateSelectedRequest(event, emit) async {
    if (event is CancelRequestSelectEvent) {
      if (selectedCancelRequest.contains(event.item)) {
        selectedCancelRequest.remove(event.item);
      } else {
        selectedCancelRequest.add(event.item);
      }
      emit(CancelRequestSelectedState());
    }
  }
}
