import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mixpod/core/functions/functions.dart';

import 'package:mixpod/domine/db/hivemodel.dart';

part 'search_bloc_event.dart';
part 'search_bloc_state.dart';

class SearchBlocBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  SearchBlocBloc() : super(SearchResult(audios: [])) {
    on<EnterInputEvent>((event, emit) {
      List<LocalSongs> songsdb = box.get("musics") as List<LocalSongs>;
      List<Audio> songall = [];

      for (var element in songsdb) {
        songall.add(
          Audio.file(
            element.uri.toString(),
            metas: Metas(
                title: element.title,
                id: element.id.toString(),
                artist: element.artist),
          ),
        );
      }

      List<Audio> searchresult = songall
          .where((element) => element.metas.title!
              .toLowerCase()
              .startsWith(event.searchInput.toLowerCase()))
          .toList();

      emit(SearchResult(audios: searchresult));
    });
  }
}
