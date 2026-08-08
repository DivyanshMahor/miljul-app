import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_class/core/utils/colors.dart';
import 'package:online_class/core/provider/new_meeting_provider.dart';
import 'package:online_class/feature/home/widgets/customer_button.dart';

import '../../../resources/start_meeting_method.dart';

class NewMeetingScreen extends ConsumerStatefulWidget {
  const NewMeetingScreen({super.key});

  @override
  ConsumerState<NewMeetingScreen> createState() => _NewMeetingScreenState();
}

class _NewMeetingScreenState extends ConsumerState<NewMeetingScreen> {
  //Controllers for meeting id and name.
  late TextEditingController meetingIdController;
  late TextEditingController nameController;
  @override
  void initState() {

    //read initial meetings state
    final meetingState =  ref.read(meetingProvider);


    //pre fill meeting id with random generated roomId

    meetingIdController = TextEditingController(text: meetingState.roomID  );

    // pre fill name with users's display name for google login
    nameController =  TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName??"",
    );
    super.initState();
  }

  @override
  void dispose() {
    //dispose controller
    meetingIdController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //watch provider state (mic/camera settings,roomId)
    final meetingState  = ref.watch(meetingProvider);


    return Scaffold(
      backgroundColor: bodyColor,
      appBar: AppBar(title: Text("Start a Meeting")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
            // Show Meeting ID, Randomly generated
            SizedBox(
              height: 60,
              child: TextField(
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  fillColor: Colors.green
                      .withAlpha(30)
                  ,
                  filled: true,
                  border : InputBorder.none,
                  hintText: "Meeting Id: ${meetingState.roomID}",
                  hintStyle: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),

            //Name input
            SizedBox(
              height: 60,
              child: TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  fillColor: Colors.green.withAlpha(30),
                  filled: true,
                  border: InputBorder.none,
                  hintText: "Name",),
              ),
            ),
            
            //Toggle mic option
            SwitchListTile.adaptive(
                title: Text("Mute Microphone"),
                value: meetingState.isMicOff, onChanged: (val) => ref.read(meetingProvider.notifier).toggleMic(val)),

            //Toggle camera option
            SwitchListTile(
              title: Text("Turn Off Camera"),
                value: meetingState.isCameraOff,
                onChanged: (val) =>
                    ref.read(
                        meetingProvider.notifier).toggleCamera(val) ),

            //state meeting button
            CustomButton(text: "Start a Meeting", onPressed: (){
              //Call startMeeting method with name inputs

              startMeeting(ref, context, nameController);

            })
            
          ],
        ),
      ),
    );
  }
}
