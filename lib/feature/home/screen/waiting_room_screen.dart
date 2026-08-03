 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_class/core/provider/new_meeting_provider.dart';
import 'package:online_class/core/provider/waiting_room_provider.dart';
import 'package:online_class/feature/home/screen/meeting_room_screen.dart';
import 'package:online_class/feature/home/widgets/bounching.dor.dart';
import 'package:online_class/route.dart';

class WaitingApprovalScreen extends ConsumerWidget {
  //Required data passed from previous screen
  final String roomId;
  final String userId;
  final bool micOff;
  final bool camOff;
  const WaitingApprovalScreen({
    super.key,
    required this.roomId,
    required this.userId,
    required this.micOff,
    required this.camOff});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch the approval status provider using roomId and userId
    final statusAsync = ref.watch(approvalStateProvider((roomId, userId)));

    return statusAsync.when(
        data: (data) {
      final status = data?['status']; //status can be "approved", "rejected", or null

      //if host approved the request
      if(status == "approved"){

        //add navigation after current frame to avoid build errors
        WidgetsBinding.instance.addPostFrameCallback((_){

          NavigationHelper.pushReplacement(
              context, 
              MeetingRoomScreen(
              name: data?["name"]??"",
              roomId: roomId,
              isCameraOff: camOff,
              isMicOff: micOff,
              isHost: false,

          ));

        });

      }

      //if host rejected the request
      else if (status == "rejected"){
        return const Scaffold(
          backgroundColor: Colors.yellow,
          body: Center(child: Text("You were denied entry"),),
        );
      }
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Waiting for host approval...",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 5,),
            //custom bouncing dots widget to show loading animation during waiting for approval
            ThreeBouncingDot(color: Colors.blue, size: 8,  ),
          ],
        ),

        ),
      );

    },

        //if something goes wrong
        error: (err,_)=> Scaffold(body: Center(child: Text("Error: $err "),),) ,

        //while fetching approval status
        loading: ()=> Scaffold(body: Center(child: CircularProgressIndicator(),),) ,) ;
  }
}
