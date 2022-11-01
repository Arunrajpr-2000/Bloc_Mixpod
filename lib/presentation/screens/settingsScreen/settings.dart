// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpod/application/cubit/player_cubit/player_cubit.dart';
import 'package:mixpod/presentation/widgets/about_dialogue.dart';
import 'package:mixpod/presentation/widgets/drawer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

// bool temp = true;

class ScreenSettings extends StatelessWidget {
  ScreenSettings({Key? key}) : super(key: key);

  bool notify = true;

  switchvalues(context) async {
    notify = context.read<PlayerCubit>().noti(await getswitchstate());
  }

  Future<bool> saveSwitchvalue(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    return prefs.setBool("switchState", value);
  }

  Future<bool> getswitchstate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? notify = prefs.getBool("switchState");
    return notify ?? true;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      switchvalues(context);
    });
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff2b2b29)),
        backgroundColor: Colors.grey.shade200,
        title: GradientText("Settings",
            style: const TextStyle(
                fontFamily: "poppinz",
                fontSize: 20,
                fontWeight: FontWeight.w500),
            colors: const [
              Color(0xffdd0021),
              Color(0xff2b2b29),
            ]),
        centerTitle: true,
      ),
      drawer: const ScreenDrawer(),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.notifications,
              color: Color(0xff2b2b29),
            ),
            title: const Text(
              'Notification',
              style: TextStyle(
                color: Color(0xff2b2b29),
              ),
            ),
            trailing: Switch(
                activeColor: const Color(0xffdd0021),
                value: notify,
                onChanged: (value) {
                  notify = context.read<PlayerCubit>().noti(value);
                  saveSwitchvalue(value);
                }),
          ),
          ListTile(
            onTap: () {
              Share.share(
                  'hey! check out this new app \n https://play.google.com/store/apps/details?id=in.brototype.mixpod');
            },
            leading: const Icon(
              Icons.share,
              color: Color(0xff2b2b29),
            ),
            title: const Text(
              'Share',
              style: TextStyle(
                color: Color(0xff2b2b29),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.lock,
              color: Color(0xff2b2b29),
            ),
            title: Text(
              'Privacy policy',
              style: TextStyle(
                color: Color(0xff2b2b29),
              ),
            ),
          ),
          ListTile(
              leading: const Icon(
                Icons.gavel,
                color: Color(0xff2b2b29),
              ),
              title: const Text(
                'Terms & conditions',
                style: TextStyle(
                  color: Color(0xff2b2b29),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return const LicensePage(
                    applicationName: 'M I X P O D',
                    applicationVersion: '1.0.0',
                  );
                }));
              }),
          ListTile(
            leading: const Icon(
              Icons.error_outline,
              color: Color(0xff2b2b29),
            ),
            title: const Text(
              'About',
              style: TextStyle(
                color: Color(0xff2b2b29),
              ),
            ),
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return AboutDialogueBox();
                },
              );
            },
          ),
          const Expanded(child: SizedBox()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Version',
                style: TextStyle(
                  color: Color(0xff2b2b29),
                ),
              ),
              Text(
                '1.0.0',
                style: TextStyle(
                  color: Color(0xff2b2b29),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          )
        ],
      ),
    );
  }
}
