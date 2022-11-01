import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:mixpod/application/cubit/player_cubit/player_cubit.dart';
import 'package:mixpod/domine/db/hivemodel.dart';
import 'package:mixpod/infrastructure/class/box_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'application/bloc/Fav_bloc/favourite_bloc.dart';
import 'application/bloc/search_bloc/search_bloc_bloc.dart';
import 'presentation/screens/splash Screen/splash.dart';

late SharedPreferences preferences;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LocalSongsAdapter());

  await Hive.openBox<List>(boxname);
  final box = Boxes.getinstance();

  preferences = await SharedPreferences.getInstance();
  preferences.setBool('isPlaying', false);

  List? favoritekeys1 = box.keys.toList();
  if (!favoritekeys1.contains('favorites')) {
    List<dynamic> favoritelist = [];
    box.put('favorites', favoritelist);
  }

  List? recentkeys1 = box.keys.toList();
  if (!recentkeys1.contains('recent')) {
    List<dynamic> recentlist = [];
    box.put('recent', recentlist);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlayerCubit()),
        BlocProvider(create: (context) => SearchBlocBloc()),
        BlocProvider(create: (context) => FavouriteBloc()),
      ],
      child: MaterialApp(
        title: 'M I X P O D',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        home: const ScreenSplash(),
      ),
    );
  }
}
