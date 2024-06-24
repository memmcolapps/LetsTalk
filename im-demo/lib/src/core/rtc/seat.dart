
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_demo/src/core/rtc/participant.dart';

class Seat {
  /// user id
  String? uid;

  /// stream id
  String? streamId;

  /// microphone id
  String? microphoneId;
  // Participant? participant;
  // Peer? peer;
  UserInfo? user;
  bool talking;
  bool microphoneOpened;
  bool cameraOpened;

  Seat({
    this.uid,
    this.streamId,
    this.microphoneId,
    // this.participant,
    // this.peer,
    this.user,
    this.talking = true,
    this.microphoneOpened = true,
    this.cameraOpened = true,
  });

  // bool get isIdle => null == participant;

// bool get cameraOff =>!participant!.renderer.srcObject!.getVideoTracks()[0].enabled;
}
