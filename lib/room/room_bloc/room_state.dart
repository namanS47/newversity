part of 'room_bloc.dart';

@immutable
abstract class RoomState {}

class RoomInitial extends RoomState {}

class AudioToggleState extends RoomState {}

class VideoToggleState extends RoomState {}

class ShareToggleState extends RoomState {}
