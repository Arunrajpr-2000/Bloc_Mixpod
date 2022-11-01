import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpod/application/bloc/Fav_bloc/favourite_bloc.dart';
import 'package:mixpod/application/cubit/player_cubit/player_cubit.dart';
import 'package:mixpod/core/functions/functions.dart';
import 'package:mixpod/infrastructure/open%20audio/openaudio.dart';
import 'package:mixpod/presentation/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';


class Fav_tab extends StatelessWidget {
  const Fav_tab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child:
          BlocBuilder<FavouriteBloc, FavouriteState>(builder: (context, state) {
        var likedSongs = [];

        if (state is FavDelete && state.props[0] != null) {
          likedSongs = state.props[0] as List<dynamic>;
        }
        if (likedSongs == null || likedSongs.isEmpty) {
          return Center(
            child: GradientText("No Favourites",
                style: const TextStyle(
                    fontFamily: "poppinz",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                colors: const [
                  Color(0xffdd0021),
                  Color(0xff2b2b29),
                ]),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                for (var element in likedSongs) {
                  PlayLikedSong.add(
                    Audio.file(
                      element.uri!,
                      metas: Metas(
                        title: element.title,
                        id: element.id.toString(),
                        artist: element.artist,
                      ),
                    ),
                  );
                }
                PlayMyAudio(allsongs: PlayLikedSong, index: index)
                    .openAsset(index: index, audios: PlayLikedSong);

                showBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    // backgroundColor: Colors.blueGrey.withOpacity(0.8),
                    context: context,
                    builder: (ctx) => MiniPlayer(
                          index: index,
                          audiosongs: PlayLikedSong,
                        ));
                context.read<PlayerCubit>().changeVisibility();
              },
              child: ListTile(
                leading: QueryArtworkWidget(
                    id: likedSongs[index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: ClipOval(
                      child: Image.asset(
                        'assets/ArtMusicMen.jpg.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )),
                trailing: IconButton(
                  onPressed: () {
                    // setState(() {
                    //   likedSongs.removeAt(index);
                    //   box.put("favorites", likedSongs);
                    // });
                    context
                        .read<FavouriteBloc>()
                        .add(FavouriteRemoveEvent(index: index));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                        "Removed From Favourites",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: const Color(0xffdd0021),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ));
                  },
                  icon: const Icon(Icons.favorite, color: Colors.red),
                ),
                title: Text(
                  likedSongs[index].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color(0xff2b2b29),
                      fontFamily: "poppinz",
                      fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  likedSongs[index].artist == '<unknown>'
                      ? 'unknown'
                      : likedSongs[index].artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color(0xff2b2b29),
                      fontFamily: "poppinz",
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            itemCount: likedSongs.length,
          );
        }
      }),
    );
  }
}