import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:online_class/feature/home/screen/waiting_approval_screen.dart';
import 'package:online_class/route.dart';
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
          extendButtons: [
            // waiting list button (only for host can see),
            if(widget.isHost)
              StreamBuilder(stream: FirebaseFirestore.instance
                  .collection("rooms")
                  .doc(widget.roomId)
                  .collection("waitingList")
                  .where("status", isEqualTo: "waiting")
                  .snapshots(),
                  builder: (context, snapshot){
                final waitingCount = snapshot.data?.docs.length ?? 0;
                return IconButton(onPressed: (){
                  NavigationHelper.push(context, WaitingApprovalScreen(roomId: widget.roomId),);
                }, icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.people, color: Colors.white),
                    if(waitingCount > 0)
                      Positioned(
                        right: 0,
                        top: -5,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            waitingCount.toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color:Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ));
                  },

              ),
          ]
        )

      ),),


    );
  }
}
