import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/flow/teacher/bank_account/model/bank_request_model.dart';
import 'package:newversity/flow/teacher/bank_account/model/bank_response_model.dart';
import 'package:newversity/network/webservice/exception.dart';

import '../../../../di/di_initializer.dart';
import '../../webservice/teacher_base_repository.dart';

part 'bank_account_events.dart';

part 'bank_account_states.dart';

class BankAccountBloc extends Bloc<BankAccountEvents, BankAccountStates> {
  String teacherId = CommonUtils().getLoggedInUser();
  final TeacherBaseRepository _teacherBaseRepository =
      DI.inject<TeacherBaseRepository>();

  BankAccountBloc() : super(BankAccountInitialState()) {
    on<AddBankAccountEvent>((event, emit) async {
      await addBankAccountInfo(event, emit);
    });

    on<FetchBankDetailsEvent>((event, emit) async {
      await fetchBankDetails(event, emit);
    });
  }

  Future<void> addBankAccountInfo(event, emit) async {
    if (event is AddBankAccountEvent) {
      emit(AddingBankAccountState());
      try {
        await _teacherBaseRepository.addBankAccount(
            teacherId, event.addBankRequestModel);
        emit(AddedBankAccountState());
      } catch (exception) {
        if (exception is BadRequestException) {
          emit(
              AddingBankAccountFailureState(msg: exception.message.toString()));
        }
        emit(AddingBankAccountFailureState(msg: "Something went wrong"));
      }
    }
  }

  Future<void> fetchBankDetails(event, emit) async {
    if (event is FetchBankDetailsEvent) {
      emit(FetchingBankDetailsState());
      try {
        final response = await _teacherBaseRepository.getBankDetails(teacherId);
        if(response?.id != null) {
          emit(FetchedBankDetailsState(bankResponseModel: response));
        } else {
          FetchingBankDetailsFailureState(msg: "please add bank account");
        }
      } catch (exception) {
        if (exception is BadRequestException) {
          emit(FetchingBankDetailsFailureState(
              msg: exception.message.toString()));
        }
        emit(FetchingBankDetailsFailureState(msg: "Something went wrong"));
      }
    }
  }
}
