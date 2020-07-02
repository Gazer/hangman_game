import 'package:flutter/material.dart';

class KeyboardWidget extends StatelessWidget {
  final List<String> letters = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ".split("");
  final Map<String, bool> guesses;
  final void Function(String) onLetterTap;

  KeyboardWidget({Key key, this.guesses, this.onLetterTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nButtons = letters.length;

    return LayoutBuilder(
      builder: (_, BoxConstraints box) {
        var buttonsPerRow = nButtons / 3;
        var buttonWidth = box.maxWidth / buttonsPerRow;
        var buttonHeight = box.maxHeight / 3;

        return Wrap(
          children: letters.map((l) {
            var alreadySelected = guesses[l] == true;

            return InkWell(
              onTap: alreadySelected
                  ? null
                  : () {
                      onLetterTap(l);
                    },
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                child: Center(
                  child: Text(
                    l,
                    style: alreadySelected
                        ? TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey)
                        : TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
