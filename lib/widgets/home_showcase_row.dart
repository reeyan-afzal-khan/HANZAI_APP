import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

Widget getVoiceRow(
    BuildContext context,
    AssetsAudioPlayer assetsAudioPlayer,
    bool isEndButtonL,
    bool isEndButtonR,
    bool darkMode,
    bool playAudio,
    int track) {
  return Row(children: <Widget>[
    Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: IconButton(
            onPressed: () => {
                  assetsAudioPlayer.stop(),
                  playAudio = false,
                  if (isEndButtonL)
                    {ShowCaseWidget.of(context).dismiss()}
                  else
                    {ShowCaseWidget.of(context).previous()}
                },
            icon: Icon(
              isEndButtonL ? Icons.cancel_rounded : Icons.arrow_circle_left,
              size: 30,
              color: darkMode ? Colors.grey[800] : Colors.lightBlue[800],
            ))),
    const Spacer(flex: 1),
    IconButton(
        onPressed: () => {
              if (!playAudio)
                {
                  playAudio = true,
                  assetsAudioPlayer
                      .open(Audio("assets/audios/menu/$track.mp3")),
                  Timer(const Duration(seconds: 3), () => {playAudio = false})
                }
            },
        icon: Icon(
          Icons.volume_up,
          size: 35,
          color: darkMode ? Colors.grey[800] : Colors.lightBlue[800],
        )),
    const Spacer(flex: 1),
    Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: IconButton(
            onPressed: () => {
                  assetsAudioPlayer.stop(),
                  playAudio = false,
                  if (isEndButtonR)
                    {ShowCaseWidget.of(context).dismiss()}
                  else
                    {ShowCaseWidget.of(context).next()}
                },
            icon: Icon(
              isEndButtonR ? Icons.cancel_rounded : Icons.arrow_circle_right,
              size: 30,
              color: darkMode ? Colors.grey[800] : Colors.lightBlue[800],
            ))),
  ]);
}
