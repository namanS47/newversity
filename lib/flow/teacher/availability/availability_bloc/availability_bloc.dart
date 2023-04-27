import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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
  List<AvailabilityArguments> alreadyAvailableList = [];
  Map<String, List<AvailabilityModel>> dateTimeMap = {};
  SlotType? sessionType = SlotType.both;
  DateTime selectedDate = DateTime.now();
  bool showUpdateAvailabilityWidget = false;
  bool isCalenderView = false;
  int editedSlotIndex = -1;

  AvailabilityBloc() : super(AvailabilityInitial()) {
    on<RemoveAvailabilityArgumentsEvent>((event, emit) {
      availabilityList.removeAt(event.index);
      emit(RemoveAvailabilityArgumentsState());
    });

    on<AddAvailabilityArgumentsEvent>((event, emit) {
      availabilityList.add(AvailabilityArguments(sessionType: sessionType));
      showUpdateAvailabilityWidget = true;
      emit(AddAvailabilityArgumentsState());
    });

    on<SaveAvailabilityEvent>((event, emit) async {
      await saveAvailability(emit);
    });

    on<SaveAlreadyAvailabilityEvent>((event, emit) async {
      await saveAlreadyAvailability(emit);
    });

    on<UpdateAvailabilityPageEvent>((event, emit) async {
      isCalenderView = !isCalenderView;
      emit(UpdatedAvailabilityPageState());
    });

    on<FetchAvailabilityArgumentEvent>((event, emit) async {
      showUpdateAvailabilityWidget = false;
      await fetchAvailability(emit, event);
    });

    on<UpdateEditedSlotEvent>((event, emit) async {
      editedSlotIndex = event.index;
      emit(UpdatedEditSlotState());
    });

    on<FetchTeacherAvailabilityDateEvent>((event, emit) async {
      await fetchTeacherAvailabilityDate(emit, event);
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
        alreadyAvailableList = response
            .where((element) => !element.booked!)
            .map((e) => AvailabilityArguments(
                availabilityId: e.availabilityId,
                selectedStartTime: TimeOfDay.fromDateTime(e.startDate!),
                selectedEndTime: TimeOfDay.fromDateTime(e.endDate!),
                booked: e.booked,
                selectedDate: e.startDate))
            .toList();
        emit(FetchAvailabilitySuccessState(
            availabilityList: alreadyAvailableList));
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

  saveAlreadyAvailability(Emitter emit) async {
    emit(SavingAlreadyAvailabilityState());
    final alreadyAvailabilityModelList = alreadyAvailableList
        .map((it) => AvailabilityModel(
            availabilityId: it.availabilityId,
            teacherId: teacherId,
            startDate: DateTimeUtils.getDateTimeFromTimeOfDay(
                selectedDate, it.selectedStartTime!),
            endDate: DateTimeUtils.getDateTimeFromTimeOfDay(
                selectedDate, it.selectedEndTime!),
            sessionType: sessionType.toString().split('.').last,
            booked: false))
        .toList();

    if (isDatesOverlapping(alreadyAvailabilityModelList)) {
      return emit(
          SavingAlreadyAvailabilityFailureState(msg: "Overlapping dates"));
    }

    try {
      await availabilityRepository.saveAvailability(AddAvailabilityRequestModel(
          availabilityList: alreadyAvailabilityModelList));
      emit(SavedAlreadyAvailabilityState());
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(SavingAlreadyAvailabilityFailureState(
            msg: exception.message.toString()));
      } else {
        emit(
            SavingAlreadyAvailabilityFailureState(msg: "Something went wrong"));
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

  bool isAddedAlreadyAvailabilityValid() {
    for (var element in alreadyAvailableList) {
      if (element.selectedStartTime == null ||
          element.selectedEndTime == null) {
        return false;
      }
    }
    return true;
  }

  Future<void> fetchTeacherAvailabilityDate(Emitter<AvailabilityState> emit,
      FetchTeacherAvailabilityDateEvent event) async {
    emit(FetchingTeacherAvailabilityDateState());
    try {
      final response = await availabilityRepository
          .fetchAvailability(FetchAvailabilityRequestModel(
        teacherId: teacherId,
      ));
      if (response != null && response.isNotEmpty) {
        Map<String, List<AvailabilityModel>> mapOfDateTime = {};
        for (var element in response) {
          if (mapOfDateTime.containsKey(
              DateTimeUtils.getBirthFormattedDateTime(element.startDate!))) {
            mapOfDateTime[
                    DateTimeUtils.getBirthFormattedDateTime(element.startDate!)]
                ?.add(element);
          } else {
            List<AvailabilityModel> lisOfAvailabilityModel = [];
            lisOfAvailabilityModel.add(element);
            mapOfDateTime[DateTimeUtils.getBirthFormattedDateTime(
                element.startDate!)] = lisOfAvailabilityModel;
          }
        }
        dateTimeMap = mapOfDateTime;
        List<MapEntry<String, List<AvailabilityModel>>> listOfEntries =
            dateTimeMap.entries.toList();
        listOfEntries.sort((a, b) => DateTimeUtils.getDateTime(a.key)
            .month
            .compareTo(DateTimeUtils.getDateTime(b.key).month));
        listOfEntries.sort((a, b) => DateTimeUtils.getDateTime(a.key)
            .compareTo(DateTimeUtils.getDateTime(b.key)));
        dateTimeMap = Map.fromEntries(listOfEntries);
        emit(FetchedTeacherAvailabilityDateState());
      } else {
        emit(NotFoundTeacherAvailabilityDateState());
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingTeacherAvailabilityDateFailureState(
            msg: exception.message.toString()));
      } else {
        emit(FetchingTeacherAvailabilityDateFailureState(
            msg: "Something went wrong"));
      }
    }
  }
}
