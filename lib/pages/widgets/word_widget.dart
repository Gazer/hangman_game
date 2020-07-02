import 'package:flutter/material.dart';

class WordWidget extends StatelessWidget {
  final String word;
  final Map<String, bool> guesses;
  final bool showAll;

  const WordWidget({
    Key key,
    this.word,
    this.guesses,
    this.showAll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: word
              .split("")
              .map((e) => _LetterWidget(e, showAll || guesses[e] == true))
              .toList(),
        ));
  }
}

class _LetterWidget extends StatelessWidget {
  final String letter;
  final bool show;

  _LetterWidget(this.letter, this.show);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(show ? letter : ""),
        SizedBox(
          height: 2,
        ),
        Container(
          height: 2,
          width: 20,
          color: Colors.grey,
        ),
      ],
    );
  }
}
