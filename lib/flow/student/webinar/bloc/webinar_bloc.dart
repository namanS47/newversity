import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/student/webinar/data/webinar_repository.dart';
import 'package:newversity/network/webservice/exception.dart';

import '../data/model/webinar_details_response_model.dart';

part 'webinar_event.dart';
part 'webinar_state.dart';

class WebinarBloc extends Bloc<WebinarEvent, WebinarState> {
  final _webinarRepository = DI.inject<WebinarRepository>();
  String studentId = CommonUtils().getLoggedInUser();

  WebinarBloc() : super(WebinarInitial()) {
    on<FetchWebinarListEvent>((event, emit) async {
      emit(FetchWebinarListLoadingState());
      try {
        final response = await _webinarRepository.fetchWebinarList();
        emit(FetchWebinarListSuccessState(webinarList: response));
      } catch(exception) {
        if(exception is BadRequestException) {
          emit(FetchWebinarListFailureState(message: exception.message ?? "something went wrong"));
        } else {
          emit(FetchWebinarListFailureState(message: "something went wrong"));
        }
      }
    });

    on<RegisterForWebinarEvent>((event, emit) async {
      emit(RegisterForWebinarLoadingState(webinarId: event.webinarId));
      try{
        _webinarRepository.registerForWebinar(event.webinarId, StudentsInfoList(studentId: studentId, agenda: event.agenda));
        emit(RegisterForWebinarSuccessState(webinarId: event.webinarId));
      } catch(exception) {
        if(exception is RegisterForWebinarFailureState) {
          emit(RegisterForWebinarFailureState());
        }
      }
    });
  }
}
