import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpod/application/cubit/player_cubit/player_cubit.dart';
import 'package:mixpod/core/functions/functions.dart';
import 'package:mixpod/domine/db/hivemodel.dart';
import 'package:mixpod/infrastructure/open%20audio/openaudio.dart';
import 'package:mixpod/presentation/screens/HomeScreen/home.dart';
import 'package:mixpod/presentation/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../playlistWidgets/add_to_playlist_from_home.dart';

class SongList extends StatefulWidget {
  SongList({Key? key}) : super(key: key);

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  List<dynamic>? likedsongs = [];

  @override
  void initState() {
    databasesongs = box.get('musics');
    likedsongs = box.get("favorites");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: audiosongs.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            showBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                context: context,
                builder: (ctx) => MiniPlayer(
                      index: index,
                      audiosongs: audiosongs,
                    ));
            context.read<PlayerCubit>().changeVisibility();

            PlayMyAudio(index: index, allsongs: audiosongs)
                .openAsset(audios: audiosongs, index: index);

            addrecent(index: index);
          },
          title: Text(
            audiosongs[index].metas.title.toString(),
            maxLines: 1,
            style: const TextStyle(
                color: Color(0xff2b2b29),
                fontFamily: "poppinz",
                fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            audiosongs[index].metas.artist.toString() == '<unknown>'
                ? 'unknown '
                : audiosongs[index].metas.artist.toString(),
            maxLines: 1,
            style: const TextStyle(
                color: Color(0xff2b2b29),
                fontFamily: "poppinz",
                fontWeight: FontWeight.w300),
          ),
          leading: QueryArtworkWidget(
            id: int.parse(audiosongs[index].metas.id.toString()),
            type: ArtworkType.AUDIO,
            nullArtworkWidget: ClipOval(
              child: Image.asset(
                'assets/ArtMusicMen.jpg.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Add To PlayList--->
                              ListTile(
                                title: GradientText("Add to Playlist",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontFamily: "poppinz",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    colors: const [
                                      Color(0xffdd0021),
                                      Color(0xff2b2b29),
                                    ]),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  showModalBottomSheet(
                                      backgroundColor: const Color(0xffdd0021),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      context: context,
                                      builder: (context) =>
                                          PlaylistNow(song: audiosongs[index]));
                                },
                              ),
                              //ADD TO FAVOURITES----->
                              likedsongs!
                                      .where((element) =>
                                          element.id.toString() ==
                                          databasesongs![index].id.toString())
                                      .isEmpty
                                  ? ListTile(
                                      title: GradientText("Add to Favourite",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "poppinz",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                          colors: const [
                                            Color(0xffdd0021),
                                            Color(0xff2b2b29),
                                          ]),
                                      onTap: () async {
                                        final songs = box.get("musics")
                                            as List<LocalSongs>;
                                        final temp = songs.firstWhere(
                                            (element) =>
                                                element.id.toString() ==
                                                audiosongs[index]
                                                    .metas
                                                    .id
                                                    .toString());
                                        favorites = likedsongs!;
                                        favorites.add(temp);
                                        box.put("favorites", favorites);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                            "Added to Favourites",
                                            style: TextStyle(
                                              fontFamily: "poppinz",
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor:
                                              const Color(0xffdd0021),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ));

                                        Navigator.of(context).pop();
                                      },
                                    )
                                  : ListTile(
                                      title: GradientText(
                                          "Remove from Favourites",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "poppinz",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                          colors: const [
                                            Color(0xffdd0021),
                                            Color(0xff2b2b29),
                                          ]),
                                      onTap: () async {
                                        likedsongs?.removeWhere((elemet) =>
                                            elemet.id.toString() ==
                                            databasesongs![index]
                                                .id
                                                .toString());
                                        await box.put("favorites", likedsongs!);
                                        // setState(() {});

                                        Navigator.of(context).pop();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                            "Remove from Favourites",
                                            style: TextStyle(
                                              fontFamily: "poppinz",
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor:
                                              const Color(0xffdd0021),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ));
                                      },
                                    ),
                            ]),
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xff2b2b29),
            ),
          ),
        );
      },
    );
  }
}
