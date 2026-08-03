//Notifier for controlling join meeting state

import 'package:flutter_riverpod/legacy.dart';
import 'package:online_class/core/model/join_meeting_model.dart';

class JoinMeetingNotifier extends StateNotifier<JoinMeetingState> {
  JoinMeetingNotifier() : super(
    JoinMeetingState(isMicOff: false, isCameraOff: false, errorMessage: null),
  );

  //toggle microphone state
void toggleMic(bool value){
  state = state.copyWith(isMicOff: value);
}

//toggle camera state
void toggleCamera(bool value){
  state = state.copyWith(isCameraOff: value);
}

//set an error message (usefully when meeting join fails).
void setError(String? message){
  state  = state.copyWith(errorMessage: message);
}

}

//riverpod provider for joiningMeetingNotifier
//autoDispose clear state automatically when not used

final joinMeetingProvider =
    StateNotifierProvider.autoDispose<JoinMeetingNotifier, JoinMeetingState>(
        (ref) => JoinMeetingNotifier()
    );
