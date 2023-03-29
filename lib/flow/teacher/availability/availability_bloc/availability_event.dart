part of 'availability_bloc.dart';

@immutable
abstract class AvailabilityEvent {}

class AddAvailabilityArgumentsEvent extends AvailabilityEvent {}

class RemoveAvailabilityArgumentsEvent extends AvailabilityEvent {
  RemoveAvailabilityArgumentsEvent({required this.index});
  final int index;
}

class SaveAvailabilityEvent extends AvailabilityEvent {}

class FetchAvailabilityArgumentEvent extends AvailabilityEvent {
  FetchAvailabilityArgumentEvent({required this.date});
  final DateTime date;
}

class RemoveAvailability extends AvailabilityEvent {
  RemoveAvailability({required this.id});
  final String id;
}
