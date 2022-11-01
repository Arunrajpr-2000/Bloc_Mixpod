import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpod/application/cubit/Playlist_Add_Dlt/playlist_add_dlt_cubit.dart';
import 'package:mixpod/core/functions/functions.dart';

import 'package:mixpod/domine/db/hivemodel.dart';
import 'package:mixpod/infrastructure/class/box_class.dart';
import 'package:on_audio_query/on_audio_query.dart';

class songadd extends StatelessWidget {
  String playlistName;
  songadd({Key? key, required this.playlistName}) : super(key: key);

  final box = Boxes.getinstance();

  getSongs() {
    databaseSong = box.get("musics") as List<LocalSongs>;
    playlistSongmodel = box.get(playlistName)!.cast<LocalSongs>();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        getSongs();
      },
    );
    return BlocProvider(
      create: (context) => PlaylistAddDltCubit(),
      child: Container(
          color: Colors.grey.shade300,
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
          child: ListView.builder(
            itemCount: databaseSong.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                    leading: SizedBox(
                      height: 45,
                      width: 45,
                      child: QueryArtworkWidget(
                        id: databaseSong[index].id!,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(15),
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: Container(
                          height: 45,
                          width: 45,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                              image: AssetImage("assets/ArtMusicMen.jpg.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      databaseSong[index].title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: "poppinz",
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2b2b29),
                          fontSize: 15),
                    ),
                    trailing:
                        BlocBuilder<PlaylistAddDltCubit, PlaylistAddDltState>(
                            builder: (context, state) {
                      return playlistSongmodel
                              .where((element) =>
                                  element.id.toString() ==
                                  databaseSong[index].id.toString())
                              .isEmpty
                          ? IconButton(
                              onPressed: () async {
                                // playlistSongmodel.add(databaseSong[index]);
                                // await box.put(
                                //     widget.playlistName, playlistSongmodel);

                                context.read<PlaylistAddDltCubit>().changeIcon(
                                    iconData: Icons.add,
                                    playListName: playlistName,
                                    song: databaseSong[index]);
                                //setState(() {});
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Color(0xff2b2b29),
                              ))
                          : IconButton(
                              onPressed: () async {
                                // playlistSongmodel.removeWhere((elemet) =>
                                //     elemet.id.toString() ==
                                //     databaseSong[index].id.toString());

                                // await box.put(
                                //     widget.playlistName, playlistSongmodel);
                                // setState(() {});

                                context.read<PlaylistAddDltCubit>().changeIcon(
                                    iconData: Icons.remove,
                                    playListName: playlistName,
                                    song: databaseSong[index]);
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Color(0xff2b2b29),
                              ));
                    })),
              );
            },
          )),
    );
  }
}
