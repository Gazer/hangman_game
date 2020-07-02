import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:hangman_game/ads.dart';
import 'package:hangman_game/pages/game_page.dart';
import 'package:hangman_game/pages/gameover_page.dart';
import 'package:hangman_game/pages/welcome_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseAdMob.instance.initialize(appId: Ads.appId);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.grey[400],
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryTextTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomePage(),
      routes: {
        "play": (_) => GamePage(),
        "gameOver": (_) => GameOverPage(),
      },
    );
  }
}
