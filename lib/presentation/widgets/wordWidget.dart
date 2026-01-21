import 'package:flutter/material.dart';

import '../../models/letterItem.dart';
import 'letterWidget.dart';

class WordWidget extends StatefulWidget {
  const WordWidget(
      {super.key,
      required this.updateSelected,
      required this.items,
      required this.selectColor});

  final Function(LetterItem) updateSelected;
  final List<LetterItem> items;
  final Color selectColor;

  @override
  State<WordWidget> createState() => _WordWidgetState();
}

class _WordWidgetState extends State<WordWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widget.items.map((e) {
        if (!e.notLetter && !e.visible) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => widget.updateSelected(e),
              child: LetterWidget(
                item: e,
                selectColor: widget.selectColor,
              ));
        } else {
          return LetterWidget(
            item: e,
            selectColor: widget.selectColor,
          );
        }
      }).toList(),
    );
  }
}
