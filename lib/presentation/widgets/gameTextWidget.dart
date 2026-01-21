import 'package:flutter/material.dart';
import 'wordWidget.dart';

import '../../models/letterItem.dart';
import '../../models/textItem.dart';

class TextWidget extends StatefulWidget {
  const TextWidget(
      {super.key,
      required this.items,
      required this.updateSelected,
      required this.item,
      required this.easy,
      required this.selectColor});

  final List<LetterItem> items;
  final TextItem item;
  final bool easy;
  final Function(LetterItem) updateSelected;
  final Color selectColor;

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  List<List<LetterItem>> words = [];

  @override
  void initState() {
    super.initState();

    _createWords();
  }

  _createWords() {
    words.clear();
    List<LetterItem> word = [];
    bool wordFinished = false;
    for (var item in widget.items) {
      if (item.notLetter) {
        word.add(item);
        wordFinished = true;
      } else if (wordFinished) {
        wordFinished = false;
        words.add(word);
        word = [];
        word.add(item);
      } else {
        word.add(item);
      }
    }
    words.add(word);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height - 320,
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
              primary: true,
              child: Wrap(
                children: words
                    .map((e) => WordWidget(
                        updateSelected: (letter) =>
                            widget.updateSelected(letter),
                        items: e,
                        selectColor: widget.selectColor))
                    .toList(),
              )),
        ),
      ),
    );
  }
}
