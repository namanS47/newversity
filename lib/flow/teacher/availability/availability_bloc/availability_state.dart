part of 'availability_bloc.dart';

@immutable
abstract class AvailabilityState {}

class AvailabilityInitial extends AvailabilityState {}

class AddAvailabilityArgumentsState extends AvailabilityState {}

class RemoveAvailabilityArgumentsState extends AvailabilityState {}

class SaveAvailabilityLoadingSate extends AvailabilityState {}

class SaveAvailabilitySuccessSate extends AvailabilityState {}

class SaveAvailabilityFailureSate extends AvailabilityState {
  SaveAvailabilityFailureSate({required this.message});

  final String message;
}

class FetchAvailabilityLoadingState extends AvailabilityState {}

class FetchAvailabilitySuccessState extends AvailabilityState {
  FetchAvailabilitySuccessState({required this.availabilityList});

  final List<AvailabilityArguments> availabilityList;
}

class FetchAvailabilityFailureState extends AvailabilityState {
  FetchAvailabilityFailureState({required this.message});

  final String message;
}

class SomethingWentWrongState extends AvailabilityState {
  SomethingWentWrongState({required this.message});

  final String message;
}

class FetchingTeacherAvailabilityDateState extends AvailabilityState {}

class FetchedTeacherAvailabilityDateState extends AvailabilityState {}

class FetchingTeacherAvailabilityDateFailureState extends AvailabilityState {
  String msg;
  FetchingTeacherAvailabilityDateFailureState({required this.msg});
}

class NotFoundTeacherAvailabilityDateState extends AvailabilityState {}

class UpdatedAvailabilityPageState extends AvailabilityState {}

class UpdatedEditSlotState extends AvailabilityState {}

class SavingAlreadyAvailabilityState extends AvailabilityState {}

class SavedAlreadyAvailabilityState extends AvailabilityState {}

class SavingAlreadyAvailabilityFailureState extends AvailabilityState {
  final String msg;
  SavingAlreadyAvailabilityFailureState({required this.msg});
}
