//represents the current state of the meeting room

class  MeetingRoomState {
  final String elapsedTime;
  MeetingRoomState({required this.elapsedTime});

  //create a copy of the state with update value
  MeetingRoomState copyWith({String? elapsedTime}){
    return MeetingRoomState  (elapsedTime: elapsedTime?? this.elapsedTime);
  }
}