import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/teacher/availability/data/model/add_availability_request_model.dart';
import 'package:newversity/flow/teacher/availability/data/model/fetch_availability_request_model.dart';
import 'package:newversity/flow/teacher/availability/data/repository/availability_repository.dart';
import 'package:newversity/network/webservice/exception.dart';
import 'package:newversity/utils/date_time_utils.dart';
import 'package:newversity/utils/enums.dart';

import '../data/availability_arguments.dart';
import '../data/model/availability_model.dart';

part 'availability_event.dart';

part 'availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  final AvailabilityRepository availabilityRepository =
      DI.inject<AvailabilityRepository>();
  String teacherId = CommonUtils().getLoggedInUser();
  List<AvailabilityArguments> availabilityList = [];
  SlotType? sessionType = SlotType.both;
  DateTime selectedDate = DateTime.now();
  bool showUpdateAvailabilityWidget = false;

  AvailabilityBloc() : super(AvailabilityInitial()) {
    on<RemoveAvailabilityArgumentsEvent>((event, emit) {
      availabilityList.removeAt(event.index);
      emit(RemoveAvailabilityArgumentsState());
    });

    on<AddAvailabilityArgumentsEvent>((event, emit) {
      availabilityList.add(AvailabilityArguments());
      showUpdateAvailabilityWidget = true;
      emit(AddAvailabilityArgumentsState());
    });

    on<SaveAvailabilityEvent>((event, emit) async {
      await saveAvailability(emit);
    });

    on<FetchAvailabilityArgumentEvent>((event, emit) async {
      showUpdateAvailabilityWidget = false;
      await fetchAvailability(emit, event);
    });
  }

  fetchAvailability(Emitter emit, FetchAvailabilityArgumentEvent event) async {
    emit(FetchAvailabilityLoadingState());
    try {
      final response = await availabilityRepository
          .fetchAvailability(FetchAvailabilityRequestModel(
        teacherId: teacherId,
        date: event.date,
      ));
      if (response != null) {
        // availabilityList =
        //     response.where((element) => !element.booked!)
        //         .map((e) => AvailabilityArguments(
        //       selectedStartTime: TimeOfDay.fromDateTime(e.startDate!),
        //       selectedEndTime: TimeOfDay.fromDateTime(e.endDate!),
        //       booked: e.booked,
        //       selectedDate: e.startDate
        //     )).toList();
        emit(FetchAvailabilitySuccessState(availabilityList: response));
      } else {
        emit(FetchAvailabilityFailureState(message: "Something went wrong"));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(SomethingWentWrongState(message: exception.message.toString()));
      } else {
        emit(FetchAvailabilityFailureState(message: "Something went wrong"));
      }
    }
  }

  saveAvailability(Emitter emit) async {
    emit(SaveAvailabilityLoadingSate());
    final availabilityModelList = availabilityList
        .map((it) => AvailabilityModel(
            teacherId: teacherId,
            startDate: DateTimeUtils.getDateTimeFromTimeOfDay(
                selectedDate, it.selectedStartTime!),
            endDate: DateTimeUtils.getDateTimeFromTimeOfDay(
                selectedDate, it.selectedEndTime!),
            sessionType: sessionType.toString().split('.').last,
            booked: false))
        .toList();

    if (isDatesOverlapping(availabilityModelList)) {
      return emit(SomethingWentWrongState(message: "Overlapping dates"));
    }

    try {
      await availabilityRepository.saveAvailability(
          AddAvailabilityRequestModel(availabilityList: availabilityModelList));
      emit(SaveAvailabilitySuccessSate());
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(SomethingWentWrongState(message: exception.message.toString()));
      } else {
        emit(SomethingWentWrongState(message: "Something went wrong"));
      }
    }
  }

  bool isDatesOverlapping(List<AvailabilityModel> availabilityModelList) {
    availabilityModelList.sort((i1, i2) {
      return i1.startDate!.compareTo(i2.startDate!);
    });
    for (int i = 1; i < availabilityModelList.length; i++) {
      if (availabilityModelList[i - 1]
              .endDate!
              .compareTo(availabilityModelList[i].startDate!) >
          0) {
        return true;
      }
    }
    return false;
  }

  bool isAddedAvailabilityValid() {
    for (var element in availabilityList) {
      if (element.selectedStartTime == null ||
          element.selectedEndTime == null) {
        return false;
      }
    }
    return true;
  }
}
