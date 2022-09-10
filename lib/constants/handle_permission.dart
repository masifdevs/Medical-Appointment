import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/agora.dart';
import 'package:flutter_localization_master/widgets/audio_call.dart';
import 'package:flutter_localization_master/widgets/video_call.dart';
import 'package:permission_handler/permission_handler.dart';

class CallPermissionHandler {
  static ClientRole _role = ClientRole.Broadcaster;

  static Future<void> joinVideoCall(context, String name) async {
    await handleCameraAndMic(Permission.camera);
    await handleCameraAndMic(Permission.microphone);
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CallPage(channelName: CHANNEL_NAME, role: _role, name: name),
      ),
    );
  }

  static Future<void> joinAudioCall(context) async {
    await handleCameraAndMic(Permission.microphone);
    // push video page with given channel name
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AudioCallPage(
          channelName: CHANNEL_NAME,
          role: _role,
        ),
      ),
    );
  }

  static Future<void> handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
  }
}
