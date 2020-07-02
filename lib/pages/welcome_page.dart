import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman_game/ads.dart';
import 'package:hangman_game/end_loop_controller.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final loopController = EndLoopController("Dead", 4.0);
  final Random r = Random();
  bool loading = true;
  List<String> words;
  BannerAd _banner;

  int playCount = 0;
  InterstitialAd _interstitialAd;
  bool _isInterstitialReady = false;

  @override
  void initState() {
    super.initState();

    _interstitialAd = InterstitialAd(
      adUnitId: Ads.inter,
      listener: (MobileAdEvent event) {
        switch (event) {
          case MobileAdEvent.loaded:
            _isInterstitialReady = true;
            break;
          case MobileAdEvent.failedToLoad:
            _isInterstitialReady = false;
            break;
          case MobileAdEvent.closed:
            _play();
            break;
          default:
        }
      },
    );
    _interstitialAd.load();

    _loadWords();
    _loadBanner();
  }

  @override
  void dispose() {
    _banner.dispose();
    _interstitialAd.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Expanded(
            flex: 10,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: FlareActor(
                "assets/HangMan.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "Dead",
                controller: loopController,
              ),
            ),
          ),
          Spacer(),
          if (loading)
            CircularProgressIndicator()
          else
            RaisedButton(
              onPressed: () {
                if (playCount >= 3 && _isInterstitialReady) {
                  _interstitialAd.show();
                  playCount = 0;
                } else {
                  playCount++;
                  _play();
                }
              },
              child: Text("Jugar!"),
            ),
          Spacer(),
        ],
      ),
    );
  }

  _play() async {
    var i = r.nextInt(words.length);

    await _banner.dispose();
    _banner = null;

    await Navigator.pushNamed(context, "play",
        arguments: words[i].toUpperCase());

    _loadBanner();
  }

  _loadWords() async {
    var text = await rootBundle.loadString("assets/words.txt");
    words = text.split("\n");

    print("Tengo ${words.length} palabras");

    setState(() {
      loading = false;
    });
  }

  _loadBanner() {
    _banner = BannerAd(
      adUnitId: Ads.banner,
      size: AdSize.banner,
    );

    _banner
      ..load()
      ..show(
        anchorType: AnchorType.top,
        anchorOffset: 40,
      );
  }
}
