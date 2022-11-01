import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpod/application/bloc/search_bloc/search_bloc_bloc.dart';
import 'package:mixpod/core/functions/functions.dart';

import 'package:mixpod/infrastructure/class/box_class.dart';
import 'package:mixpod/infrastructure/open%20audio/openaudio.dart';

import 'package:mixpod/domine/db/hivemodel.dart';

import 'package:mixpod/presentation/widgets/miniplayer.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  List<LocalSongs> songsdb = [];
  List<Audio> songall = [];
  String search = '';

  final box = Boxes.getinstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Container(
                child: TextField(
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        fillColor: Colors.grey,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff2b2b29), width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff2b2b29), width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                        suffixIcon: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.red[500],
                            )),
                        hintText: 'search a song',
                        filled: true,
                        hintStyle: const TextStyle(color: Colors.white)),
                    onChanged: (value) {
                      search = value;

                      context
                          .read<SearchBlocBloc>()
                          .add(EnterInputEvent(searchInput: value));
                    }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<SearchBlocBloc, SearchBlocState>(
              builder: (context, state) {
                List<Audio> searchResult = state.props as List<Audio>;
                return search.isNotEmpty
                    ? searchResult.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: searchResult.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                    showBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        backgroundColor:
                                            Colors.blueGrey.withOpacity(0.8),
                                        context: context,
                                        builder: (ctx) => MiniPlayer(
                                              index: index,
                                              audiosongs: searchResult,
                                            ));
                                    PlayMyAudio(
                                            index: index,
                                            allsongs: searchResult)
                                        .openAsset(
                                            audios: audiosongs, index: index);
                                  },
                                  child: ListTile(
                                    leading: QueryArtworkWidget(
                                        id: int.parse(
                                            searchResult[index].metas.id!),
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: ClipOval(
                                          child: Image.asset(
                                            'assets/ArtMusicMen.jpg.jpg',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    title: Text(
                                      searchResult[index].metas.title!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontFamily: "poppinz",
                                          color: Color(0xff2b2b29),
                                          fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      searchResult[index].metas.artist!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontFamily: "poppinz",
                                          color: Color(0xff2b2b29),
                                          fontSize: 15),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(30),
                            child: GradientText("No Result Found",
                                style: const TextStyle(
                                    fontFamily: "poppinz",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                colors: const [
                                  Color(0xffdd0021),
                                  Color(0xff2b2b29),
                                ]),
                          )
                    : const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
