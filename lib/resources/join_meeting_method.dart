import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_class/core/provider/join_meeting_provider.dart';
import 'package:online_class/core/utils/utils.dart';
import 'package:online_class/feature/home/screen/waiting_room_screen.dart';
import 'package:online_class/route.dart';

void joinMeeting(
WidgetRef ref,
BuildContext context,
TextEditingController nameController,
TextEditingController meetingIdController,
) async {
  //get room id and name from text fields
  final meetingId = meetingIdController.text.trim();
  final name = nameController.text.trim();

  //current logged-in firebase user
  final user =  FirebaseAuth.instance.currentUser!;

  //Riverpod notifier and state for joinMeetingProvider

  final notifier = ref.read(joinMeetingProvider.notifier);
  final state = ref.read(joinMeetingProvider);

  //validation room id and can't be empty

  if(meetingId.isEmpty || name.isEmpty ) {
    notifier.setError("Room ID is Required");
    return;
  }

  //check if the meeting room exists in firestore
  final doc = await FirebaseFirestore.instance
  .collection("rooms")
  .doc(meetingId)
  .get();

  if (!doc.exists){
    //if no such room exists show error
    notifier.setError("No Such Room Id found");
    
    showAppSnackbar(
        context: context,
        type: SnackbarType.error,
        description: "No such room id found to join");
    return;
  }

  //Add user into WaitingList sub-collection of the room
  //status = "waiting" (host need to approval to join)
  await FirebaseFirestore.instance
      .collection("rooms")
      .doc(meetingId)
      .collection("waitingList")
      .doc(user.uid)
  .set({
    "name":name,
    "status":"waiting"
  });

  //Navigation to WaitingApprovalScreen
  
  NavigationHelper.push(context, WaitingApprovalScreen(
    roomId: meetingId,
    userId: user.uid,
    camOff: state.isCameraOff,
    micOff: state.isMicOff,
  ));

  //show snackbar that user is waiting for approval
  showAppSnackbar(
      context: context,
      type: SnackbarType.success,
      description: "Waiting to approve from admin"

  );

}