// controls the meeting room state  (timer + remove user feature)

import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:online_class/core/model/meeting_room_model.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class MeetingRoomNotifier extends StateNotifier<MeetingRoomState> {
  MeetingRoomNotifier() : super(MeetingRoomState(elapsedTime: "00:00")){
    _startTimer();
  }

  late final Stopwatch _stopwatch; //keeps track of elapsed time
  late final Timer _timer; // repeats every second to update ui

  //start stopwatch and periodically update elapsedTime every second
  void _startTimer() {
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final seconds = _stopwatch.elapsed.inSeconds;
      final minutes = seconds ~/ 60; //convert total seconds into minutes
      final remaining = seconds % 60; //remaining seconds after minutes
      state = state.copyWith(
        elapsedTime: "${minutes.toString().padLeft(2, "0")} : ${remaining.toString().padLeft(2,"0")}",
      );
    } );
  }

  //remove a user from the meetinf room (host can kick participant)
void removeUser(ZegoUIKitUser user){
    ZegoUIKit().removeUserFromRoom([user.id]);
}

//clean up resources when provider is disposed
@override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
}
}

//provider that expose the meeting room state
//user autoDispose so when screen is closed timer + state are cleaned
final meetingRoomProvider =
StateNotifierProvider.autoDispose<MeetingRoomNotifier,
    MeetingRoomState>((ref)=>
  MeetingRoomNotifier(),
);