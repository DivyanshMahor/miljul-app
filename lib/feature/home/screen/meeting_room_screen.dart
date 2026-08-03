import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

import '../../../core/secret/key.dart';

class MeetingRoomScreen extends StatefulWidget {
  final String name;  //user display name
  final String roomId; //unique roomId
  final bool isMicOff; //mic setting when joining/starting
  final bool isCameraOff;
  final bool isHost;// whenever user is the host

  const MeetingRoomScreen({
    super.key,
    required this.name,
    required this.roomId,
    required this.isCameraOff,
    required this.isMicOff,
    required this.isHost,
  });

  @override
  State<MeetingRoomScreen> createState() => _MeetingRoomScreenState();
}

class _MeetingRoomScreenState extends State<MeetingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(child: ZegoUIKitPrebuiltVideoConference(
        appID: appID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: user?.uid??"",
        userName: widget.name,
        conferenceID: widget.roomId.trim(),
        config: ZegoUIKitPrebuiltVideoConferenceConfig()
          ..turnOnCameraWhenJoining = !widget.isCameraOff
          ..turnOnMicrophoneWhenJoining = !widget.isMicOff
          ..layout = ZegoLayout.gallery()

          //top menu bar
        ..topMenuBarConfig = ZegoTopMenuBarConfig(
          isVisible: true,
          backgroundColor: Colors.transparent,
          title: "",
            buttons: [
              ZegoMenuBarButtonName.switchCameraButton,
              ZegoMenuBarButtonName.switchAudioOutputButton,
            ],
          // extendButtons: [
            //waiting list button (only for host can see),
            // if(widget.isHost)
              // StreamBuilder(stream: FirebaseFirestore.instance
              //     .collection("rooms")
              //     .doc(widget.roomId)
              //     .collection("waitingList")
              //     .where("status", isEqualTo: "waiting")
              //     .snapshots()  ,

                  // builder: builder)
          // ]
        )

      ),),


    );
  }
}
