import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/room/model/room_argument.dart';
import 'package:newversity/room/room_bloc/room_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class RoomPage extends StatelessWidget {
  final RoomArguments roomArguments;

  const RoomPage({super.key, required this.roomArguments});

  Future<bool> getPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    return true;
  }

// UI to render join screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            // Function to push to meeting page
            onPressed: () async {
              await getPermissions();
              if (context.mounted) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.meetingPageRoute,
                  arguments: roomArguments
                );
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                'Join',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MeetingPage extends StatefulWidget {
  final RoomArguments roomArguments;
  final String sessionToken;

  const MeetingPage(
      {super.key, required this.sessionToken, required this.roomArguments});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage>
    implements HMSUpdateListener {
  //SDK
  late HMSSDK hmsSDK;

  // Variables required for rendering video and peer info
  HMSPeer? localPeer, remotePeer;
  HMSVideoTrack? localPeerVideoTrack, remotePeerVideoTrack;

  // Initialize variables and join room
  @override
  void initState() {
    super.initState();
    initHMSSDK();
  }

  void initHMSSDK() async {
    String? userName = widget.roomArguments.forStudents == true
        ? widget.roomArguments.sessionDetails.studentDetail?.name
        : widget.roomArguments.sessionDetails.teacherDetail?.name;
    hmsSDK = HMSSDK();
    await hmsSDK.build(); // ensure to await while invoking the `build` method
    hmsSDK.addUpdateListener(listener: this);
    hmsSDK.join(
      config:
          HMSConfig(authToken: widget.sessionToken, userName: userName ?? ""),
    );
  }

  // Clear all variables
  @override
  void dispose() {
    remotePeer = null;
    remotePeerVideoTrack = null;
    localPeer = null;
    localPeerVideoTrack = null;
    super.dispose();
  }

  // Called when peer joined the room - get current state of room by using HMSRoom obj
  @override
  void onJoin({required HMSRoom room}) {
    room.peers?.forEach((peer) {
      if (peer.isLocal) {
        localPeer = peer;
        if (peer.videoTrack != null) {
          localPeerVideoTrack = peer.videoTrack;
        }
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  // Called when there's a peer update - use to update local & remote peer variables
  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        if (!peer.isLocal) {
          if (mounted) {
            setState(() {
              remotePeer = peer;
            });
          }
        }
        break;
      case HMSPeerUpdate.peerLeft:
        if (!peer.isLocal) {
          if (mounted) {
            setState(() {
              remotePeer = null;
            });
          }
        }
        break;
      case HMSPeerUpdate.networkQualityUpdated:
        return;
      default:
        if (mounted) {
          setState(() {
            localPeer = null;
          });
        }
    }
  }

  // Called when there's a track update - use to update local & remote track variables
  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      switch (trackUpdate) {
        case HMSTrackUpdate.trackRemoved:
          if (mounted) {
            setState(() {
              peer.isLocal
                  ? localPeerVideoTrack = null
                  : remotePeerVideoTrack = null;
            });
          }
          return;
        default:
          if (mounted) {
            setState(() {
              peer.isLocal
                  ? localPeerVideoTrack = track as HMSVideoTrack
                  : remotePeerVideoTrack = track as HMSVideoTrack;
            });
          }
      }
    }
  }

  // More callbacks - no need to implement for quickstart
  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {}

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {}

  @override
  void onHMSError({required HMSException error}) {}

  @override
  void onMessage({required HMSMessage message}) {}

  @override
  void onReconnected() {}

  @override
  void onReconnecting() {}

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}

  // Widget to render a single video tile
  Widget peerTile(Key key, HMSVideoTrack? videoTrack, HMSPeer? peer) {
    return Container(
      key: key,
      child: (videoTrack != null && !(videoTrack.isMute))
          // Actual widget to render video
          ? HMSVideoView(
              track: videoTrack,
              setMirror: true,
              matchParent: true,
            )
          : Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(4),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 20.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Text(
                  peer?.name.substring(0, 1) ?? "D",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
    );
  }

  // Widget to render grid of peer tiles and a end button
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Used to call "leave room" upon clicking back button [in android]
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: (remotePeerVideoTrack == null)
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.height / 2,
                  crossAxisCount: 1),
              children: [
                if (remotePeerVideoTrack != null && remotePeer != null)
                  peerTile(Key(remotePeerVideoTrack?.trackId ?? "" "mainVideo"),
                      remotePeerVideoTrack, remotePeer),
                peerTile(Key(localPeerVideoTrack?.trackId ?? "" "mainVideo"),
                    localPeerVideoTrack, localPeer)
              ],
            ),
          ),
          bottomNavigationBar: BlocBuilder<RoomBloc, RoomState>(
            builder: (context, state) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.black,
                selectedItemColor: Colors.grey,
                unselectedItemColor: Colors.grey,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(context.read<RoomBloc>().isAudioOn
                        ? Icons.mic_off
                        : Icons.mic),
                    label: 'Mic',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(context.read<RoomBloc>().isVideoOn
                        ? Icons.videocam_off
                        : Icons.videocam),
                    label: 'Camera',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.screen_share,
                        color: context.read<RoomBloc>().isScreenShareActive
                            ? Colors.green
                            : Colors.grey,
                      ),
                      label: "ScreenShare"),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.cancel),
                    label: 'Leave Meeting',
                  ),
                ],

                //New
                onTap: (index) => _onItemTapped(index, context),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context
            .read<RoomBloc>()
            .add(RoomOverviewLocalPeerAudioToggled(hmsSDK: hmsSDK));
        break;

      case 1:
        context
            .read<RoomBloc>()

            .add(RoomOverviewLocalPeerVideoToggled(hmsSDK: hmsSDK));
        break;

      case 2:
        context
            .read<RoomBloc>()
            .add(RoomOverviewLocalPeerScreenShareToggled(hmsSDK: hmsSDK));
        break;

      case 3:
        hmsSDK.leave();
        if (widget.roomArguments.forStudents) {
          Navigator.of(context).pushReplacementNamed(
              AppRoutes.congratulationFeedback,
              arguments: widget.roomArguments.sessionDetails);
        } else {
          Navigator.of(context).pushReplacementNamed(
              AppRoutes.teacherFeedbackRoute,
              arguments: widget.roomArguments.sessionDetails);
        }
        break;
    }
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {

  }
}
