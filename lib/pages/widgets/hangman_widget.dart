import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class HangmanWidget extends StatelessWidget {
  final int lives;
  final Map<int, String> animForLives = {
    6: "Intro",
    5: "Head",
    4: "Body",
    3: "Arm1",
    2: "Arm2",
    1: "Leg1",
    0: "Leg2",
    -1: "Dead",
  };

  HangmanWidget({Key key, this.lives}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlareActor(
      "assets/HangMan.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: animForLives[lives],
    );
  }
}
