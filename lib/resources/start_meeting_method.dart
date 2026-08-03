import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_class/core/provider/new_meeting_provider.dart';
import 'package:online_class/feature/home/screen/meeting_room_screen.dart';
import 'package:online_class/route.dart';

void startMeeting(
  WidgetRef ref,
  BuildContext context,
  TextEditingController nameController,
) async {
  //current logged-in Firebase user
  final currentUser = FirebaseAuth.instance.currentUser;

  //read state from meetingProvider
  final state = ref.read(meetingProvider);

  //create a new document in firestore
  //in this collection we have mainly store a roomId and store on it
  //also check it during joining other user
  //if match the room id then call will happen on this same room

  await FirebaseFirestore.instance.collection("rooms").doc(state.roomID).set({
    "createdBy": currentUser?.uid, //who created the room
    "hostId": currentUser?.uid, // host user id
    "hostName": currentUser?.displayName,
    "timestamp": FieldValue.serverTimestamp(),
    "roomId": state.roomID, //unique room id every time
  });

  //Navigate directly to meeting RoomScreen (host joins instantly)
  NavigationHelper.pushReplacement(
    context,
    MeetingRoomScreen(
      name: nameController.text,
      roomId: state.roomID,
      isCameraOff: state.isCameraOff,
      isMicOff: state.isMicOff,
      isHost: true,
    ),
  );
}
