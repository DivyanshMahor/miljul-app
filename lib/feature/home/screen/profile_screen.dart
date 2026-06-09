import 'package:flutter/material.dart';
import 'package:online_class/core/utils/colors.dart';
import 'package:online_class/feature/auth/screen/google_login_screen.dart';
import 'package:online_class/feature/auth/service/auth_method.dart';
import 'package:online_class/route.dart';

// import 'package:zego_uikit/zego_uikit.dart';
// import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: Center(
        child: ElevatedButton(onPressed: (){
          GoogleSignInService.signOut();
          NavigationHelper.pushReplacement(context, GoogleLoginScreen() );
        }, child: Icon(Icons.exit_to_app),),
      ),
    );
  }
}
//
// class VideoConferencePage extends StatelessWidget {
//   final String conferenceID;
//
//   const VideoConferencePage({
//     Key? key,
//     required this.conferenceID,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//
// // !mark(1:8)
//       child: ZegoUIKitPrebuiltVideoConference(
//         appID: 264940009, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//         appSign: 'c028d9420add31b4e2691c30fe505895d5eccc4e1c3bb4f8f1a6349672da6931', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//         userID: 'user_id',
//         userName: 'user_name',
//         conferenceID: conferenceID,
//         config: ZegoUIKitPrebuiltVideoConferenceConfig(),
//       ),
//
//     );
//   }
// }