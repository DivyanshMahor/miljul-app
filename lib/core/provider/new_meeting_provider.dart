import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:online_class/core/model/new_meeting_model.dart';

class MeetingNotifier extends StateNotifier <MeetingState>{
  MeetingNotifier():super(
    MeetingState(
      isMicOff: false, //initially false set
      isCameraOff: false,
      roomID: Random().nextInt(999999).toString(), //random 6digit no. for roomID
    )
  );

  //turn mic on/off
void toggleMic(bool value){
  state = state.copyWith(
    isMicOff: value
  );
}

//turn camera on/off
void toggleCamera(bool value){
  state = state.copyWith(
    isCameraOff: value
  );
}
}
//Riverpod provider for MeetingNotifier
//autoDispose = clear state when not used anymore

final meetingProvider =
StateNotifierProvider.autoDispose<MeetingNotifier, MeetingState >((ref){
  return MeetingNotifier();
});