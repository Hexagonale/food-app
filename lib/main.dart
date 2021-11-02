import 'package:flutter/material.dart';

import 'screens/splash/splash.dart';

// https://www.behance.net/gallery/81589609/Food-App
void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xff4e49ff),
        backgroundColor: Colors.white,
        primaryTextTheme: const TextTheme(
          bodyText1: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        fontFamily: 'Poppins',
//      visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Splash(),
    );
  }
}
