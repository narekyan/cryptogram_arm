import 'package:flutter/material.dart';

import '../../models/letterItem.dart';

class LetterWidget extends StatefulWidget {
  const LetterWidget(
      {super.key, required this.item, required this.selectColor});

  final LetterItem item;
  final Color selectColor;

  @override
  State<LetterWidget> createState() => _LetterWidgetState();
}

class _LetterWidgetState extends State<LetterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: widget.item.selected ? widget.selectColor : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          children: [
            SizedBox(
                width: widget.item.notLetter ? 10 : 20,
                height: 20,
                child: Text((widget.item.visible || widget.item.notLetter) ? widget.item.char : ' ',
                    textAlign: TextAlign.center)),
            SizedBox(
              width: widget.item.notLetter ? 10 : 20,
              height: 2,
              child: ColoredBox(
                color: widget.item.notLetter
                    ? Colors.white
                    : widget.item.selected
                        ? Colors.grey.shade200
                        : Colors.grey,
              ),
            ),
            Text(
              widget.item.notLetter ? ' ' : widget.item.number,
              style: TextStyle(
                  color: widget.item.selected ? Colors.white : Colors.black),
            )
          ],
        ));
  }
}
