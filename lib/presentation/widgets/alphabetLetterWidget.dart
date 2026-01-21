import 'package:flutter/material.dart';

import '../../models/letterItem.dart';

class AlphabetLetterWidget extends StatefulWidget {
  const AlphabetLetterWidget(
      {super.key,
      required this.letterTapped,
      required this.item,
      required this.selectColor});

  final Function(LetterItem) letterTapped;
  final LetterItem item;
  final Color selectColor;

  @override
  State<AlphabetLetterWidget> createState() => _AlphabetLetterState();
}

class _AlphabetLetterState extends State<AlphabetLetterWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor:
            !widget.item.open ? widget.selectColor : Colors.transparent,
        onTap: () {
          if (widget.item.open || widget.item.notLetter) {
            return;
          }

          var result = widget.letterTapped(widget.item);
          if (result == true) {
            widget.item.open = true;
          }
        },
        child: Container(
            margin: const EdgeInsets.all(2),
            width: 28,
            height: 30,
            color: widget.item.notLetter
                ? Colors.transparent
                : Colors.grey.shade300,
            child: Text(
              widget.item.char,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: !widget.item.open ? Colors.black : Colors.grey.shade500,
              ),
            )));
  }
}
