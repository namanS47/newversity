part of 'room_bloc.dart';

@immutable
abstract class RoomEvent {}

class RoomOverviewLocalPeerVideoToggled extends RoomEvent {
  RoomOverviewLocalPeerVideoToggled({required this.hmsSDK});
  final HMSSDK hmsSDK;
}

class RoomOverviewLocalPeerScreenShareToggled extends RoomEvent {
  RoomOverviewLocalPeerScreenShareToggled({required this.hmsSDK});
  final HMSSDK hmsSDK;
}

class RoomOverviewLocalPeerAudioToggled extends RoomEvent {
  RoomOverviewLocalPeerAudioToggled({required this.hmsSDK});
  final HMSSDK hmsSDK;
}

class RoomOverviewLeaveRequested extends RoomEvent {
  RoomOverviewLeaveRequested();
}
