import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_class/core/utils/colors.dart';
import 'package:online_class/core/provider/new_meeting_provider.dart';

import 'package:online_class/feature/home/widgets/customer_button.dart';
import 'package:online_class/resources/join_meeting_method.dart';

import '../../../core/provider/join_meeting_provider.dart';
import '../../../resources/start_meeting_method.dart';

class JoinMeeting extends ConsumerStatefulWidget {
  const JoinMeeting({super.key});

  @override
  ConsumerState<JoinMeeting> createState() => _NewMeetingScreenState();
}

class _NewMeetingScreenState extends ConsumerState<JoinMeeting> {
  //Controllers for meeting id and name.
  late TextEditingController meetingIdController;
  late TextEditingController nameController;
  @override
  void initState() {

    //initialize the controller only

    meetingIdController = TextEditingController();

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

    //read provider state(mic, camera, errors)
    final state =  ref.watch(joinMeetingProvider);

    //access notifier to update
    final notifier = ref.read(joinMeetingProvider.notifier);



    return Scaffold(
      backgroundColor: bodyColor,
      appBar: AppBar(title: Text("Join Meeting")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Meeting Id

            SizedBox(
              height: 65,
              child: TextField(
             controller: meetingIdController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorText: state.errorMessage,
                  fillColor: Colors.green
                      .withAlpha(30)
                  ,
                  filled: true,
                  border : InputBorder.none,
                  hintText: "Meeting Id: ",
                  hintStyle: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
SizedBox(height: 10,),

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

            //Join meeting button

            CustomButton(text: "Join", onPressed: (){
              //Call JoinMeeting method with entered details
              
              joinMeeting(ref, context, nameController, meetingIdController);

              

              startMeeting(ref, context, nameController);

            }),
            SizedBox(height: 20,),
            Text("Join options",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),),

            //Toggle mic option
            SwitchListTile.adaptive(
                title: Text("Don't connect to audio"),
                value: state.isMicOff,
                onChanged: notifier.toggleMic),

            //Toggle camera option
            SwitchListTile(
                title: Text("Turn Off my video"),
                value: state.isCameraOff,
                onChanged: notifier.toggleCamera),



          ],
        ),
      ),
    );
  }
}
