import 'dart:convert';

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../models/languagesetting.dart';
import '/models/categoryModel.dart';
import '/models/textItem.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/categoryListItemWidget.dart';
import 'gamePage.dart';

import '../../resources.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  var easy = true;
  late SharedPreferences prefs;
  int selectedCategory = 0;
  List<CategoryModel> localData = []; //theLocalData;
  String packageName = "";
  int buildNumber = 0;
  bool thereIsNewVersion = false;

  @override
  initState() {
    super.initState();

    _getVersion();
    SharedPreferences.getInstance().then((value) {
      prefs = value;

      _checkConnection();
    });

    _registerToFcmTopic();
  }

  _registerToFcmTopic() async {
    await FirebaseMessaging.instance.requestPermission(provisional: true);
    await FirebaseMessaging.instance.getToken();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FirebaseMessaging.instance.subscribeToTopic("newitem");
  }

  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo.packageName.replaceAll("_", ".");
    buildNumber = int.parse(packageInfo.buildNumber);
  }

  _checkConnection() async {
    var connection = kIsWeb;
    if (!connection) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          connection = true;
        } else {}
      } on SocketException catch (_) {}
    }

    if (connection) {
      _checkIfNewVersion();
      _getData();
    } else {
      _readLocalData();
    }
  }

  _checkIfNewVersion() async {
    final systemRef = FirebaseFirestore.instance.collection('system');
    var systemData = await systemRef.get();
    var hashmap = systemData.docs.first.data();
    thereIsNewVersion = (hashmap['version'] as int) > buildNumber;
  }

  _getData() async {
    final categoriesRef =
        FirebaseFirestore.instance.collection(CategoryModel.firebaseName);
    final itemsRef =
        FirebaseFirestore.instance.collection(TextItem.firebaseName);

    var itemsData = await itemsRef.get();
    List<TextItem> textItems = [];

    var categoriesData = await categoriesRef.get();
    List<CategoryModel> categories = [];

    String? data = prefs.getString(R.keys.data);

    List<CategoryModel> oldCategories = [];
    if (data != null) {
      var items = jsonDecode(data);
      oldCategories =
          List<CategoryModel>.from(items.map((e) => CategoryModel.fromJson(e)));
    }

    try {
      for (var element in itemsData.docs) {
        var item = TextItem.fromJson(element.data());
        item.id = element.id;
        textItems.add(item);
      }

      for (var element in categoriesData.docs) {
        var item = CategoryModel.fromJson(element.data());
        item.items = textItems
            .where((element) => element.category == item.index)
            .toList();

        var oldCount = oldCategories
                .where((element) => element.index == item.index)
                .firstOrNull
                ?.items
                .length ??
            0;
        if (oldCount < item.items.length) {
          item.hasNew = true;
        }

        for (var element in item.items) {
          element.text = element.text.toUpperCase();
        }
        categories.add(item);
      }

      String json = jsonEncode(categories);

      prefs.setString(R.keys.data, json);
    } catch (e) {
      print(e);
    }

    _readLocalData();
  }

  _readLocalData() {
    String? data = prefs.getString(R.keys.data);

    if (data != null) {
      var items = jsonDecode(data);

      var categories =
          List<CategoryModel>.from(items.map((e) => CategoryModel.fromJson(e)));
      categories.sort(
          (CategoryModel a, CategoryModel b) => a.index.compareTo(b.index));

      localData = categories;
      _updateFoundsNumbers();
      setState(() {});
    }
  }

  _updateFoundsNumbers() {
    var founds = prefs.getString(R.keys.founds) ?? "";
    var foundItems = founds.split(",");

    for (var element in localData) {
      element.founds = 0;
    }
    for (var item in foundItems) {
      if (item.isEmpty) continue;
      var category = int.parse(item.split("-").first);
      if (localData[category].founds < localData[category].items.length) {
        localData[category].founds += 1;
      }
    }
  }

  _startNewOne() async {
    if (localData.isEmpty) return;

    var founds = prefs.getString(R.keys.founds) ?? "";
    var random = Random();
    var itemsCount = localData[selectedCategory].items.length;
    var nextIndex = random.nextInt(itemsCount);
    var id = localData[selectedCategory].items[nextIndex].id;
    var hasAlreadyWon = founds.contains("$selectedCategory-$id,");

    if (localData[selectedCategory].founds != itemsCount) {
      while (hasAlreadyWon) {
        nextIndex = random.nextInt(itemsCount);
        var id = localData[selectedCategory].items[nextIndex].id;
        hasAlreadyWon = founds.contains("$selectedCategory-$id,");
      }
    }
    localData[selectedCategory].hasNew = false;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyHomePage(
                title: localData[selectedCategory].title,
                easy: easy,
                category: localData[selectedCategory],
                hasAlreadyWon: hasAlreadyWon,
                textItem: localData[selectedCategory].items[nextIndex],
                languageSetting: LanguageSetting.armenian,
              )),
    );

    if (!mounted) return;

    _updateFoundsNumbers();
    if (result == R.keys.startNew) {
      _startNewOne();
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(R.strings.letsPlay),
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
        ),
        body: Column(children: [
          Container(
              width: double.maxFinite,
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
              color: Colors.grey.shade200,
              child: Text(R.strings.findPhrase)),
          const Gap(5),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(R.strings.rules)),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(R.strings.gameMode),
              CupertinoSegmentedControl(
                  children: {
                    true: Text(R.strings.easy),
                    false: Text(R.strings.hard)
                  },
                  selectedColor: Colors.deepPurpleAccent,
                  onValueChanged: (value) => setState(() {
                        easy = value;
                      }),
                  groupValue: easy),
            ],
          ),
          const Gap(10),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              itemCount: localData.length,
              separatorBuilder: (_, __) => const Gap(5),
              itemBuilder: (context, i) => CategoryListItemWidget(
                isSelected: selectedCategory == i,
                onTap: () => setState(() => selectedCategory = i),
                itemData: localData[i],
              ),
            ),
          ),
          const Gap(10),
          FilledButton(
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.deepPurpleAccent)),
              onPressed: _startNewOne,
              child: Text(
                R.strings.start,
                style: const TextStyle(fontSize: 18),
              )),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(
                text: R.strings.privacy,
                style: const TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async => launchUrl(Uri.parse(R.keys.privacyUrl)),
              )),
              const Gap(10),
              RichText(
                  text: TextSpan(
                text: R.keys.email,
                style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontStyle: FontStyle.italic),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async =>
                      launchUrl(Uri.parse('mailto:+${R.keys.email}')),
              ))
            ],
          ),
          const Gap(5),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (buildNumber > 0) Text("Version $buildNumber "),
            const Gap(5),
            if (thereIsNewVersion)
              RichText(
                  text: TextSpan(
                text: '( ${R.strings.thereIsNewVersion} )',
                style: const TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async => await launchUrl(
                      Uri.parse(R.keys.playMarketUrl + packageName)),
              ))
          ]),
          const Gap(15)
        ]));
  }
}
