class LetterItem {
  int index;
  String char;
  bool open;
  bool visible;
  bool notLetter;
  String number;
  bool selected = false;

  LetterItem(this.index, this.char, this.open, this.visible, this.notLetter,
      this.number);

  static LetterItem none = LetterItem(-1, '', false, false, false, '');

  bool isNone() => index == -1;

  @override
  String toString() {
    return ",,,index $index, char $char, open $open, visible $visible, notletter $notLetter, number $number";
  }
}