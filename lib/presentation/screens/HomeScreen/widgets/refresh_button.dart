import 'package:flutter/material.dart';
import 'package:mixpod/core/functions/functions.dart';
import 'package:mixpod/presentation/screens/HomeScreen/home.dart';

class RefreshButton extends StatelessWidget {
  RefreshButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: const Color(0xffdd0021),
      ),
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ScreenHome(audiosongs: audiosongs)),
            (route) => false);
      },
      child: const Text(
        'Refresh ',
        style: TextStyle(
            color: Colors.white,
            fontFamily: "poppinz",
            fontSize: 15,
            letterSpacing: 1,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
