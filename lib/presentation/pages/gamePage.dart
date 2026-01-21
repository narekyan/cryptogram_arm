import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/languagesetting.dart';
import '../widgets/alphabetWidget.dart';
import '../widgets/gameTextWidget.dart';
import '../../models/letterItem.dart';
import '../../models/categoryModel.dart';
import '../../resources.dart';
import '../../models/textItem.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.easy,
      required this.category,
      required this.hasAlreadyWon,
      required this.textItem,
      required this.languageSetting});

  final LanguageSetting languageSetting;
  final String title;
  final bool easy;
  final bool hasAlreadyWon;
  final CategoryModel category;
  final TextItem textItem;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var maxTryCount = R.keys.maxTryCount;
  var tryCount = R.keys.maxTryCount.toInt();
  var showWrongLetter = false;
  late bool hasAlreadyWon;
  var won = false;
  final List<LetterItem> items = [];
  late Color color;

  @override
  void initState() {
    super.initState();

    var rgb = widget.category.redGreenBlue();
    color = Color.fromARGB(255, rgb.$1, rgb.$2, rgb.$3);
    hasAlreadyWon = widget.hasAlreadyWon;

    _createLettersHashMap();
    _createItems();
  }

  _saveFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var founds = prefs.getString(R.keys.founds) ?? "";

    var newValue = "${widget.category.index}-${widget.textItem.id},";

    prefs.setString(R.keys.founds, "$founds$newValue");

    won = true;
    setState(() {
      hasAlreadyWon = true;
    });
  }

  List<String> openLetters = [];

  _createLettersHashMap() {
    String u = R.strings.letterU;
    var hashmap = <String, int>{};
    var text = widget.textItem.text;
    for (int i = 0; i < text.length; i++) {
      var char = text[i];
      if (!widget.languageSetting.alphabet.contains(char)) continue;
      if (char == u) continue;
      if (i + 1 < text.length && text[i + 1] == u) {
        char += u;
      }
      var count = hashmap[char] ?? 0;
      hashmap[char] = count + 1;
    }

    _createOpenLetters(hashmap);
  }

  _createOpenLetters(hashmap) {
    var text = widget.textItem.text;
    int visibleCount = widget.easy
        ? text.length ~/ R.keys.easyOpenFactor
        : text.length ~/ R.keys.hardOpenFactor;
    var random = Random();

    while (visibleCount > 0) {
      hashmap.forEach((String key, int value) {
        if (random.nextBool()) {
          if (visibleCount > 0) {
            openLetters.add(key);
            visibleCount -= value;
          }
        }
      });
    }
  }

  _createItems() {
    List<String> newAlphabet = [...widget.languageSetting.alphabet];
    newAlphabet.shuffle();
    String u = R.strings.letterU;

    items.clear();
    var selectFirstSpot = true;
    var text = widget.textItem.text;
    for (int i = 0; i < text.length; i++) {
      var char = text[i];
      if (char == u) continue;
      if (i + 1 < text.length && text[i + 1] == u) {
        char += u;
      }

      var open = openLetters.contains(char);

      var item = LetterItem(
          i,
          char,
          open,
          open,
          !widget.languageSetting.alphabet.contains(char),
          open ? "" : (newAlphabet.indexOf(char) + 1).toString());

      if (!item.notLetter && !item.visible && selectFirstSpot) {
        item.selected = true;
        selectFirstSpot = false;
      }

      items.add(item);
    }
  }

  _letterTapped(LetterItem item) {
    if (won) return;

    try {
      var selectedItem = items.firstWhere((element) => element.selected);
      items.firstWhere((element) =>
          item.char == element.char && selectedItem.number == element.number);

      return _selectLetter(item);
    } catch (identifier) {
      // no letter
      _wrongLetterCase();
    }
  }

  _selectLetter(LetterItem item) {
    var selectedItem = items.firstWhere((element) => element.selected);
    try {
      var nextSelected = items.firstWhere((element) =>
          !element.visible &&
          !element.notLetter &&
          (element.index > selectedItem.index) &&
          (!widget.easy ||
              widget.easy &&
                  item.char != element.char &&
                  selectedItem.number != element.number));
      print(selectedItem.toString() + "1");
      selectedItem.visible = true;
      return _winConditionCheck(item, nextSelected);
    } catch (identifier) {
      try {
        var nextSelected = items
            .firstWhere((element) => !element.visible && !element.notLetter);
        print(selectedItem.toString() + "2");
        selectedItem.visible = true;
        return _winConditionCheck(item, nextSelected);
      } catch (identifier) {
        print(selectedItem.toString() + "3");
        setState(() {
          selectedItem.visible = true;
        });
      }
    }
  }

  _updateSelected(LetterItem item) {
    for (var i = 0; i < items.length; ++i) {
      items[i].selected = false;
    }
    setState(() {
      item.selected = true;
    });
  }

  _winConditionCheck(LetterItem item, LetterItem nextSelected) {
    var selectedItemNumber =
        items.firstWhere((element) => element.selected).number;

    if (widget.easy) {
      items
          .where((element) =>
              item.char == element.char && selectedItemNumber == element.number)
          .forEach((element) {
        element.visible = true;
      });
    }

    _updateSelected(nextSelected);

    ///FOR TESTING///
    if (items
        .where((element) => !element.visible && !element.notLetter)
        .isNotEmpty) {
      if (items
          .where((element) => element.char == item.char && !element.visible)
          .isEmpty) {
        items
            .where((element) => element.number == selectedItemNumber)
            .forEach((element) {
          element.number = "";
        });

        return true;
      }
    } else {
      items
          .where((element) => element.number == selectedItemNumber)
          .forEach((element) {
        element.number = "";
      });
      for (var i = 0; i < items.length; ++i) {
        items[i].selected = false;
      }
      _showWinAlert();
    }
  }

  _showWinAlert() {
    Widget cancelButton = TextButton(
      child: Text(R.strings.good),
      onPressed: () => Navigator.pop(context),
    );
    Widget newButton = TextButton(
      child: Text(
        R.strings.startNext,
        style: TextStyle(color: color),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context, R.keys.startNew);
      },
    );

    // set up the AlertDialog

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(R.strings.winText),
            actions: [newButton, cancelButton],
          );
        });

    _saveFound();
  }

  _wrongLetterCase() {
    tryCount -= 1;
    if (tryCount == 0) {
      Widget cancelButton = TextButton(
        child: Text(R.strings.good),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(R.strings.loseText),
              actions: [cancelButton],
            );
          });
    } else {
      setState(() {
        showWrongLetter = true;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        //asynchronous delay
        setState(() {
          showWrongLetter = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.grey.shade200,
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Row(
                  children: [
                    Text(R.strings.findLetters, textAlign: TextAlign.center),
                    const Spacer(),
                    if (showWrongLetter)
                      Text(
                        R.strings.tryOtherLetter,
                        style: const TextStyle(
                          color: Colors.redAccent,
                        )
                      ),
                    const Gap(5),
                    Text(tryCount == 0 ? '' : '$tryCount'),
                    Icon(
                      tryCount == 0
                          ? Icons.heart_broken_outlined
                          : Icons.favorite,
                      color: Color.fromARGB(
                          255, 255 * tryCount ~/ maxTryCount, 0, 0),
                    )
                  ],
                ),
              ),
              const Gap(10),
              TextWidget(
                items: items,
                updateSelected: _updateSelected,
                item: widget.textItem,
                easy: widget.easy,
                selectColor: color,
              ),
              const Gap(10),
              if (hasAlreadyWon)
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    widget.textItem.author,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              if (widget.textItem.link.isNotEmpty && hasAlreadyWon)
                RichText(
                  text: TextSpan(
                    text: widget.textItem.link.contains("youtube.com")
                        ? R.strings.watch
                        : R.strings.learnMore,
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async =>
                          await launchUrl(Uri.parse(widget.textItem.link)),
                  ),
                ),
              const Spacer(),
              AlphabetWidget(
                letterTapped: _letterTapped,
                openLetters: openLetters,
                selectColor: color,
                languageSetting: widget.languageSetting,
              )
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
