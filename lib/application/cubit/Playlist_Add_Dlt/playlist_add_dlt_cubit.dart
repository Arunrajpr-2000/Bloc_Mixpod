import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mixpod/infrastructure/class/box_class.dart';
import 'package:mixpod/domine/db/hivemodel.dart';

// import 'playlist_add_dlt_cubit.dart';

part 'playlist_add_dlt_state.dart';

class PlaylistAddDltCubit extends Cubit<PlaylistAddDltState> {
  PlaylistAddDltCubit() : super(PlaySongAdd());

  void changeIcon(
      {required IconData iconData,
      required String playListName,
      required LocalSongs song}) async {
    var box = Boxes.getinstance();
    List<LocalSongs> list = box.get(playListName)!.cast<LocalSongs>();
    if (iconData == Icons.add) {
      list.add(song);
      await box.put(
        playListName,
        list,
      );
      emit(PlaySongAdd());
    } else {
      list.removeWhere((elemet) => elemet.id.toString() == song.id.toString());
      await box.put(playListName, list);
      emit(PlaySongRemove());
    }
  }
}
