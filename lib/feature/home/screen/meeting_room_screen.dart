import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_class/core/provider/join_meeting_provider.dart';
import 'package:online_class/core/provider/meeting_room_provider.dart';
import 'package:online_class/core/provider/new_meeting_provider.dart';
import 'package:online_class/core/utils/colors.dart';
import 'package:online_class/feature/home/screen/app_main_screen.dart';
import 'package:online_class/feature/home/screen/waiting_approval_screen.dart';
import 'package:online_class/route.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import '../../../core/secret/key.dart';

class MeetingRoomScreen extends ConsumerStatefulWidget {
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
  ConsumerState<MeetingRoomScreen> createState() => _MeetingRoomScreenState();
}

class _MeetingRoomScreenState extends ConsumerState<MeetingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

     final elapsedTime  = ref.watch(meetingRoomProvider).elapsedTime;  //meeting timer

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(child: Stack(
        children: [
          //zego prebuilt video conference widget
          ZegoUIKitPrebuiltVideoConference  (
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
            //action when leaving  meeting
            ..onLeave = () {
              ZegoUIKit().leaveRoom();
              //after leave clear all the state
              ref.invalidate(meetingProvider);
              ref.invalidate(meetingRoomProvider);
              ref.invalidate(joinMeetingProvider);
              NavigationHelper.pushReplacement(context, AppMainScreen());
            }

            //bottom menu bar
            ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
              maxCount: 6,
              style: ZegoMenuBarStyle.light,
              buttons: [
                ZegoMenuBarButtonName.toggleMicrophoneButton,
                ZegoMenuBarButtonName.toggleCameraButton,
                ZegoMenuBarButtonName.leaveButton,
                ZegoMenuBarButtonName.chatButton,
              ],
                extendButtons:[
                  //we can't customize on the default participant button that's what we have create a one new custom button ..
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.only(
                    right: 15,
                    left: 7,
                    top:13,
                    bottom: 13,
                  ),
                  backgroundColor: iconBackground,
                  shape: CircleBorder()
                ),
                onPressed: () async{
                  final roomSnapshot =
                  await FirebaseFirestore.instance
                      .collection("rooms")
                      .doc(widget.roomId)
                      .get();
                  final hostId = roomSnapshot['hostId'] ?? "";
                  final cuurentUsers = ZegoUIKit().getAllUsers();
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: bottomSheetColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      ),
                      builder: (_){
                    return ;
                  } );
                }, icon: Icon(Icons.group, color: Colors.white,),),
                    ],
                  ),
                ]
            ),

          ),

          //show roomId and elapsed time (host only)
          if(widget.isHost)
            Positioned(
            top: 16,
            left: 20,
            child: Text("Room ID: ${widget.roomId} $elapsedTime",
              style: TextStyle(
                  color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
),

        ],
      ),
      ),


    );
  }
  Widget _buildMemberList(String hostId, List<ZegoUIKitUser> currentUsers){
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          //header with back arrow
          Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                  size:30,
                  color:Colors.white,
                ),
                ),
                SizedBox(width: 8),
                Text("Members (${(ZegoUIKit().getAllUsers().length).toString()})"
                ,style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
          ),
          Divider(color: Colors.black26),
          SizedBox(height: 5),

        ],
      ),
    );
  }
}
