//this class repreasent the data(state) of a meeting
class MeetingState {
  final bool isMicOff;
  final bool isCameraOff;
  final String roomID;

  //Constructor to initialize the values.
  MeetingState({
    required this.isMicOff,
    required this.isCameraOff,
    required this.roomID
});

  // Create a new copy of meetingState with updated values.
  //if the parameter is not passed it keeps the old values.
  MeetingState copyWith({
    bool? isMicOff,
    bool? isCameraOff,
    String? roomID,
}){
    return MeetingState(
        isMicOff: isMicOff ?? this.isMicOff ,
        isCameraOff: isCameraOff ?? this.isCameraOff,
        roomID: roomID ?? this.roomID,
    );
  }


}