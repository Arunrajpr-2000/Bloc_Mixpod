import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:mixpod/core/functions/functions.dart';
import 'package:mixpod/domine/db/hivemodel.dart';
import 'package:mixpod/presentation/screens/HomeScreen/widgets/refresh_button.dart';
import 'package:mixpod/presentation/screens/searchScreen/search.dart';
import 'package:mixpod/presentation/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'Tab Widget/Allsongs_tab.dart';
import 'Tab Widget/favourite_tab.dart';
import 'Tab Widget/playlist_tab.dart';

List<dynamic>? recentsongsdy = [];
List<dynamic> recents = [];

class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key, required this.audiosongs}) : super(key: key);
  List<Audio> audiosongs = [];

  Icon myIcon = const Icon(Icons.search);

  Future refreshlist() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        databasesongs = box.get('musics');
      },
    );
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: ScaffoldGradientBackground(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade300,
            // Color(0xff2b2b29),
            // Color(0xffdd0021),
          ],
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xff2b2b29)),
          backgroundColor: Colors.grey.shade200,
          title: GradientText("MIXPOD",
              style: const TextStyle(
                  fontFamily: "poppinz",
                  fontSize: 20,
                  letterSpacing: 5,
                  fontWeight: FontWeight.w500),
              colors: const [
                Color(0xffdd0021),
                Color(0xff2b2b29),
              ]),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                icon: const Icon(
                  Icons.search,
                  color: Color(0xff2b2b29),
                )),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.red,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.favorite, color: Color(0xff2b2b29)),
              ),
              Tab(
                icon: Icon(Icons.home, color: Color(0xff2b2b29)),
              ),
              Tab(
                icon: Icon(Icons.library_music, color: Color(0xff2b2b29)),
              ),
            ],
          ),
        ),
        drawer: const ScreenDrawer(),
        body: TabBarView(
          children: [
            const Fav_tab(),

            // Allsongs_tab---->
            audiosongs.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GradientText("No Songs,Try to Refresh or ResTart!!",
                          style: const TextStyle(
                              fontFamily: "poppinz",
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          colors: const [
                            Color(0xffdd0021),
                            Color(0xff2b2b29),
                          ]),
                      const SizedBox(
                        height: 25,
                      ),
                      RefreshButton(),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshlist(),
                    color: Colors.red,
                    child: SongList(),
                  ),
            Playlist_tab(),
          ],
        ),
      ),
    );
  }
}

addrecent({required int index}) {
  if (recents.length < 10) {
    final songs = box.get("musics") as List<LocalSongs>;

    final temp = songs.firstWhere((element) =>
        element.id.toString() == audiosongs[index].metas.id.toString());
    recents = recentsongsdy!;
    recents.add(temp);
    box.put("recent", recents);
  } else {
    recents.removeAt(0);
    box.put("recent", recents);
  }
}
