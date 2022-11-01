import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mixpod/core/functions/functions.dart';

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  FavouriteBloc() : super(FavDelete(list: box.get('favorites'))) {
    on<FavouriteEvent>((event, emit) {
      if (event is FavouriteRemoveEvent) {
        final likedSongs = box.get('favorites');
        likedSongs!.removeAt(event.index);
        box.put('favorites', likedSongs);
        emit(FavDEleteSecnd());
        emit(FavDelete(list: likedSongs));
      }
    });
  }
}
