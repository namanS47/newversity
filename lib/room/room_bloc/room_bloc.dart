import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:meta/meta.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  bool isAudioOn = false;
  bool isVideoOn = false;
  bool isScreenShareActive = false;

  RoomBloc() : super(RoomInitial()) {
    on<RoomOverviewLocalPeerAudioToggled>(_onLocalAudioToggled);
    on<RoomOverviewLocalPeerVideoToggled>(_onLocalVideoToggled);
    on<RoomOverviewLocalPeerScreenShareToggled>(_onScreenShareToggled);
  }

  Future<void> _onLocalVideoToggled(RoomOverviewLocalPeerVideoToggled event,
      Emitter<RoomState> emit) async {
    isVideoOn = !isVideoOn;
    event.hmsSDK.switchVideo(isOn: isVideoOn);
    emit(VideoToggleState());
  }

  void _onScreenShareToggled(RoomOverviewLocalPeerScreenShareToggled event,
      Emitter<RoomState> emit) async {
    isScreenShareActive = !isScreenShareActive;
    if (isScreenShareActive) {
      event.hmsSDK.startScreenShare();
    } else {
      event.hmsSDK.stopScreenShare();
    }
    emit(ShareToggleState());
  }

  Future<void> _onLocalAudioToggled(RoomOverviewLocalPeerAudioToggled event,
      Emitter<RoomState> emit) async {
    isAudioOn = !isAudioOn;
    event.hmsSDK.switchAudio(isOn: isAudioOn);
    emit(AudioToggleState());
  }

  // Future<void> _onJoinSuccess(
  //     RoomOverviewOnJoinSuccess event, Emitter<RoomState> emit) async {
  //   if (state.isAudioMute) {
  //     hmsSdk.switchAudio(isOn: state.isAudioMute);
  //   }
  //
  //   if (state.isVideoMute) {
  //     hmsSdk.switchVideo(isOn: state.isVideoMute);
  //   }
  // }
  //
  // Future<void> _onPeerLeave(
  //     RoomOverviewOnPeerLeave event, Emitter<RoomState> emit) async {
  //   await roomObserver.deletePeer(event.hmsPeer.peerId);
  // }
}
