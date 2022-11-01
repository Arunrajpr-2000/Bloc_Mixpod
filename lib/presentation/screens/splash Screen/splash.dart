import 'package:flutter/material.dart';
import 'package:mixpod/core/functions/functions.dart';
import 'package:mixpod/presentation/screens/HomeScreen/home.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        fetchingsongs();
        gotohome(context);
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/172876e3ef491d0bd9e9de1b0ded5233-removebg-preview.png"),
                    fit: BoxFit.cover),
              ),
            ),
            GradientText("M I X P O D",
                style: const TextStyle(
                    fontFamily: "poppinz",
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
                colors: const [
                  Color(0xffdd0021),
                  Color(0xff2b2b29),
                ])
          ],
        ),
      ),
    );
  }

  Future<void> gotohome(context) async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => ScreenHome(audiosongs: audiosongs),
      ),
    );
  }
}
