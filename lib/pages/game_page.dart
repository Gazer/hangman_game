import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:hangman_game/ads.dart';
import 'package:hangman_game/pages/widgets/hangman_widget.dart';
import 'package:hangman_game/pages/widgets/keyboard_widget.dart';
import 'package:hangman_game/pages/widgets/word_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Map<String, bool> guesses = {};
  int lives = 6;

  bool _isRewardReady = false;

  void _loadRewardedAd() {
    RewardedVideoAd.instance.load(
      adUnitId: Ads.reward,
      targetingInfo: MobileAdTargetingInfo(),
    );
  }

  _onRewardedEvent(
    RewardedVideoAdEvent event, {
    String rewardType,
    int rewardAmount,
  }) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        _isRewardReady = true;
        break;
      case RewardedVideoAdEvent.failedToLoad:
        _isRewardReady = false;
        break;
      case RewardedVideoAdEvent.closed:
        _isRewardReady = false;
        _loadRewardedAd();
        break;
      case RewardedVideoAdEvent.rewarded:
        Navigator.pop(context);
        setState(() {
          lives += 3;
        });
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();

    RewardedVideoAd.instance.listener = _onRewardedEvent;

    _loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    String word = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text("Te queda ${lives + 1} vidas"),
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
            child: HangmanWidget(lives: lives),
          ),
          WordWidget(
            word: word,
            guesses: guesses,
          ),
          Expanded(
            child: KeyboardWidget(
              guesses: guesses,
              onLetterTap: (letter) {
                setState(() {
                  guesses[letter] = true;

                  if (!word.contains(letter)) {
                    lives--;
                  } else {
                    var found = word.split("").fold(0, (count, letter) {
                      if (guesses[letter] == true) {
                        return count + 1;
                      }
                      return count;
                    });
                    if (found == word.length) {
                      showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                          title: new Text("Ganaste"),
                          content: new Text(
                            "Genio del univeso, gracias por salvarme",
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cerrar'),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    }
                  }

                  if (lives == -1) {
                    if (_isRewardReady) {
                      _askReward(context, word);
                    } else {
                      _gameOver();
                    }
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _askReward(BuildContext context, String word) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("¿Otra oportunidad?"),
        content: new Text(
          "Mira un video para obtener 3 vidas extras",
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ver Video'),
            onPressed: () {
              RewardedVideoAd.instance.show();
            },
          ),
          FlatButton(
            child: Text('Cerrar'),
            onPressed: () {
              Navigator.pop(context);

              _gameOver();
            },
          )
        ],
      ),
    );
  }

  _gameOver() {
    String word = ModalRoute.of(context).settings.arguments;
    Navigator.pushReplacementNamed(
      context,
      "gameOver",
      arguments: word,
    );
  }
}
