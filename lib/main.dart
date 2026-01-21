import 'package:flutter/material.dart';

import 'resources.dart';
import 'presentation/pages/startPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/*

next ideas::

add watch Ad and get one heart after 5 mistakes

 */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const MyApp());


}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: R.strings.letsPlay,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const StartPage(),
    );
  }
}

// ------------ \/\/\/\/\/ ------------

