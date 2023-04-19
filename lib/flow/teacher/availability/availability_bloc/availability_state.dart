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
  final List<AvailabilityModel> availabilityList;
}

class FetchAvailabilityFailureState extends  AvailabilityState {
  FetchAvailabilityFailureState({required this.message});
  final String message;
}

class SomethingWentWrongState extends AvailabilityState {
  SomethingWentWrongState({required this.message});
  final String message;
}
