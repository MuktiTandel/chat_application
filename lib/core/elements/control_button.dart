import 'package:chat_application/core/elements/customcolor.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 6.w,
            height: 3.h,
            child: const CircularProgressIndicator( color:  CustomColor.primary,),
          );
        } else if (playing != true) {
          return IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.play_arrow_rounded),
            iconSize: 5.h,
            onPressed: player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.pause_rounded),
            iconSize: 5.h,
            onPressed: player.pause,
          );
        } else {
          return IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.replay_rounded),
            iconSize: 5.h,
            onPressed: () => player.seek(Duration.zero),
          );
        }
      },
    );
  }
}