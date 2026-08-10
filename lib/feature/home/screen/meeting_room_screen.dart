import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_class/core/provider/join_meeting_provider.dart';
import 'package:online_class/core/provider/meeting_room_provider.dart';
import 'package:online_class/core/provider/new_meeting_provider.dart';
import 'package:online_class/core/utils/colors.dart';
import 'package:online_class/core/utils/utils.dart';
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

class _MeetingRoomScreenState extends ConsumerState<MeetingRoomScreen>  {

  //build mic/camera icons + remove button
  Widget _buildUserStatusIcons(ZegoUIKitUser user){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        //show remove button nly if current user  is host
        //and not trying to remove themselves
        if(widget.isHost &&
            user.id != FirebaseAuth.instance.currentUser?.uid) ...[
          SizedBox(width: 8),
          IconButton(onPressed: () => _showRemoveUserDialgo(user),

            icon: Icon(Icons.remove_circle, color: Colors.red, size:20),
          ),
        ],

        //mic status icon
        ValueListenableBuilder<bool>(
          valueListenable: user.microphone,
          builder: (_,isMicOn,__) =>Icon(
            isMicOn ? Icons.mic : Icons.mic_off,
            color:Colors.white24,
            size:20,
          ),
        ),
        SizedBox(width: 8),

        //Camera status icon
        ValueListenableBuilder<bool>(
          valueListenable: user.camera,
          builder: (_,isCameraOn,__) =>Icon(
            isCameraOn ? Icons.videocam : Icons.videocam_off,
            color:Colors.white24,
            size:20,
          ),
        ),
      ],
    );
  }

  void _showRemoveUserDialgo(ZegoUIKitUser user){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: Text("Remove User"),
        content:  Text("Remove ${user.name} from the meeting"),
        actions: [
          IconButton(onPressed: Navigator.of(context).pop, icon: Text("Cancel")),
          TextButton(
            onPressed:(){
        Navigator.of(context).pop();
      ref.read(meetingRoomProvider.notifier).removeUser(user);
      showAppSnackbar(
          context: context,
          type: SnackbarType.success,
          description: "${user.name} removem from the meeting"
      );
      },

            child: Text("Remove"),
          ),
        ],
      );
    });
  }


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
                  final currentUsers = ZegoUIKit().getAllUsers();
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: bottomSheetColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      ),
                      builder: (_){
                    return _buildMemberList(hostId, currentUsers) ;
                  } );
                }, icon: Icon(Icons.group, color: Colors.white,),
                      ),
                   
                   //show total participant count on top
                      Positioned(child: Text(ZegoUIKit().getAllUsers().length.toString(),
                      style: TextStyle(color: Colors.white),
                      ),),

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

          //list of participants
          Expanded(
            child: StreamBuilder(
                stream: ZegoUIKit().getUserListStream(),
                builder: (_, snapshot) {
            final  participants = snapshot.data ?? [];
            if (participants.isEmpty){
              return const Center(
                child: Text("No participants yet",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder
              (
              itemCount: participants.length,
                itemBuilder: (context, index) {
                final user = participants[index];
                final isHost = user.id == hostId;
                return ListTile(

                  //show profile picture of all user (from firestore)
                  leading: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                  .collection("users")
                          .doc(user.id)
                          .snapshots(),
                      builder : (context, userSnapshot){
                        String? photoUrl;
                        if(userSnapshot.hasData &&
                        userSnapshot.data!.exists){
                          final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                          photoUrl = userData?['photoUrl'];



                        }  //fallback for current user
                        if(
                        photoUrl == null
                            &&
                            user.id == FirebaseAuth.instance.currentUser?.uid
                        ){

                          photoUrl = FirebaseAuth.instance.currentUser?.photoURL;
                        }
                           return CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          backgroundImage: photoUrl != null && photoUrl.isNotEmpty ?
                          NetworkImage(photoUrl):NetworkImage("https://cdn.pixabay.com/photo/2023/02/18/icon-7797704_640.png"),
                        );
                }
                  ) ,
                 
                  //show username with (you) or host
                  title: Text(_getUserDisplayName(user, isHost),
                  style: TextStyle(
                    color: Colors.white,
                  fontWeight: isHost ?
                  FontWeight.w600
                      : FontWeight.normal,
                  ),
                  ),
                  //mic, Camera, remove button
                  trailing: _buildUserStatusIcons(user),
                );

                } );
          },

          ),
          ),


        ],
      ),
    );
  }

  //helper: add (you) and host to names
String _getUserDisplayName(ZegoUIKitUser user, bool isHost) {

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isCurrentUser = user.id == currentUserId;
    String displayName = user.name;
    if(isCurrentUser) displayName += "(You)";
    if(isHost) displayName += "(Host)";
    return displayName;
}

//display to confirm removing a user fro meeting (only for host can remove),

//display to confirm removing a user from meeting (only for host can remove),








}
