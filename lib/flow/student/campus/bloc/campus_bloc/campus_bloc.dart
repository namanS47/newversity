import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/student/campus/data/pensil_token_request_model.dart';
import 'package:newversity/flow/student/webservice/student_base_repository.dart';
import 'package:newversity/storage/preferences.dart';

import '../../data/pensil_token_response_model.dart';

part 'campus_event.dart';

part 'campus_states.dart';

class StudentCampusBloc extends Bloc<StudentCampusEvents, StudentCampusStates> {
  final studentRepository = DI.inject<StudentBaseRepository>();

  StudentCampusBloc() : super(StudentCampusInitialState()) {
    on<FetchUserCommunityTokenEvent>((event, emit) async {
      emit(FetchUserCommunityTokenLoadingState());
      final studentDetails = await DI.inject<Preferences>().getStudentDetails();
      final response = await studentRepository.fetchCommunityUserToken(
        PensilTokenRequestModel(
          referenceIdInSource: studentDetails.studentId!,
          name: studentDetails.name ?? "Guest",
          picture: studentDetails.profilePictureUrl,
          createUser: true
        )
      );
      if(response != null) {
        emit(FetchUserCommunityTokenSuccessState(pensilResponse: response));
      } else {
        emit(FetchUserCommunityTokenFailureState());
      }
    });
  }
}
