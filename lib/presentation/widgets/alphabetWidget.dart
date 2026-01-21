import 'package:flutter/material.dart';

import '../../models/languagesetting.dart';
import 'alphabetLetterWidget.dart';
import '../../models/letterItem.dart';

class AlphabetWidget extends StatefulWidget {
  const AlphabetWidget(
      {super.key,
      required this.letterTapped,
      required this.openLetters,
      required this.selectColor,
      required this.languageSetting});

  final LanguageSetting languageSetting;
  final List<String> openLetters;
  final Color selectColor;
  final Function(LetterItem) letterTapped;

  @override
  State<AlphabetWidget> createState() => _AlphabetWidgetState();
}

class _AlphabetWidgetState extends State<AlphabetWidget> {
  List items = [LetterItem];

  @override
  void initState() {
    super.initState();

    items.clear();
    for (int i = 0; i < widget.languageSetting.alphabet.length; i++) {
      var char = widget.languageSetting.alphabet[i];

      items.add(LetterItem(
          i,
          char,
          widget.openLetters.contains(char),
          widget.openLetters.contains(char),
          !widget.languageSetting.alphabet.contains(char),
          ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    var index = 0;
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
        child: Column(
          children: [
            for (var number in widget.languageSetting.layout)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (; index < number; index++)
                    AlphabetLetterWidget(
                        letterTapped: (item) {
                          return widget.letterTapped(item);
                        },
                        item: items[index],
                        selectColor: widget.selectColor)
                ],
              )
          ],
        ));
  }
}
