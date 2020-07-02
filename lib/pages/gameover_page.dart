import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:hangman_game/end_loop_controller.dart';
import 'package:hangman_game/pages/widgets/word_widget.dart';

class GameOverPage extends StatelessWidget {
  final loopController = EndLoopController("Dead", 4.0);

  GameOverPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String word = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text("Juego Terminado"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.black,
            ),
      ),
      body: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: FlareActor(
              "assets/HangMan.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "Dead",
              controller: loopController,
            ),
          ),
          WordWidget(
            word: word,
            guesses: {},
            showAll: true,
          ),
          Expanded(
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Volver"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
