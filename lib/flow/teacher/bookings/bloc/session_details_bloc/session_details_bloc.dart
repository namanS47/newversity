import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/flow/teacher/home/model/session_response_model.dart';
import 'package:newversity/network/webservice/exception.dart';

import '../../../../../di/di_initializer.dart';
import '../../../home/model/session_request_model.dart';
import '../../../webservice/teacher_base_repository.dart';

part 'session_details_event.dart';

part 'session_details_states.dart';

class SessionDetailsBloc
    extends Bloc<SessionDetailsEvents, SessionDetailsStates> {
  final TeacherBaseRepository _teacherBaseRepository =
      DI.inject<TeacherBaseRepository>();
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
      await updateSelectedRequest(event, emit);
    });

    on<FetchSessionDetailByIdEvent>((event, emit) async {
      await fetchSessionDetailByIdEvent(event, emit);
    });

    on<SessionAddingEvent>((event, emit) async {
      await saveSessionDetail(event, emit);
    });
  }

  Future<void> saveSessionDetail(event, emit) async {
    emit(SavingSessionDetailState());
    try {
      if (event is SessionAddingEvent) {
        await _teacherBaseRepository
            .saveSessionDetail(event.sessionSaveRequest);
        emit(SavedSessionDetails());
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        SavingSessionDetailFailureState(message: exception.message.toString());
      } else {
        SavingSessionDetailFailureState(message: "Something Went Wrong");
      }
    }
  }

  Future<void> fetchSessionDetailByIdEvent(event, emit) async {
    emit(FetchingSessionDetailByIdState());
    try {
      if (event is FetchSessionDetailByIdEvent) {
        final response =
            await _teacherBaseRepository.getSessionDetailsById(event.id);
        emit(FetchedSessionDetailByIdState(sessionDetails: response));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingSessionDetailByIdFailureState(
            msg: exception.message.toString()));
      } else {
        emit(
            FetchingSessionDetailByIdFailureState(msg: "Something went wrong"));
      }
    }
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
