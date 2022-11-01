import 'package:flutter/cupertino.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AboutDialogueBox extends StatelessWidget {
  const AboutDialogueBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Column(
        children: [
          GradientText("M I X P O D",
              style: const TextStyle(
                  fontFamily: "poppinz",
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
              colors: const [
                Color(0xffdd0021),
                Color(0xff2b2b29),
              ]),
          const Text('1.0.0')
        ],
      ),
      content: const Text('MIXPOD is designed and developed by\n ARUNRAJ'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'OK',
            style: TextStyle(
              color: Color(0xffdd0021),
            ),
          ),
        ),
      ],
    );
  }
}
