//state for joining a meeting
class JoinMeetingState{ //class
  final bool isMicOff;
  final bool isCameraOff;
  final String? errorMessage;

  JoinMeetingState({ // contstructor
    required this.isMicOff,
    required this.isCameraOff,
    this.errorMessage,
  });

  //copyWith allows immutability while updating only specific fields
  JoinMeetingState copyWith ({
    bool? isMicOff,
    bool? isCameraOff,
    String? errorMessage,
}){
    return JoinMeetingState(
      isMicOff: isMicOff ?? this.isMicOff,
      isCameraOff: isCameraOff ?? this.isCameraOff,
      errorMessage: errorMessage,
    );

}

}