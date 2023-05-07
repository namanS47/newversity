part of 'availability_bloc.dart';

@immutable
abstract class AvailabilityEvent {}

class AddAvailabilityArgumentsEvent extends AvailabilityEvent {}

class RemoveAvailabilityArgumentsEvent extends AvailabilityEvent {
  RemoveAvailabilityArgumentsEvent({required this.index});

  final int index;
}

class RemoveAddedAvailabilityArgumentsEvent extends AvailabilityEvent {
  RemoveAddedAvailabilityArgumentsEvent({required this.index});

  final int index;
}

class SaveAvailabilityEvent extends AvailabilityEvent {}

class SaveAlreadyAvailabilityEvent extends AvailabilityEvent {}

class FetchAvailabilityArgumentEvent extends AvailabilityEvent {
  FetchAvailabilityArgumentEvent({required this.date});

  final DateTime date;
}

class FetchTeacherAvailabilityDateEvent extends AvailabilityEvent {}

class RemoveAvailability extends AvailabilityEvent {
  RemoveAvailability({required this.id});

  final String id;
}

class UpdateEditedSlotEvent extends AvailabilityEvent {
  final int index;
  UpdateEditedSlotEvent({required this.index});
}

class UpdateAvailabilityPageEvent extends AvailabilityEvent {
  UpdateAvailabilityPageEvent({this.selectedDate});
  final DateTime? selectedDate;
}
