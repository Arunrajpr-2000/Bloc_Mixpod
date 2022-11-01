import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayMyAudio {
  final int index;
  List<Audio> allsongs;

  bool? notify;
  Future<bool?> setNotifyValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notify = await prefs.getBool("switchState");

    return notify;
  }

  PlayMyAudio({required this.allsongs, required this.index});
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  openAsset({List<Audio>? audios, required int index}) async {
    await audioPlayer.open(
      Playlist(audios: allsongs, startIndex: index),
      loopMode: LoopMode.playlist,
      showNotification: notify == null || notify == true ? true : false,
      autoStart: true,
    );
  }
}
