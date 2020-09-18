import 'package:flutter/material.dart';

import 'views/home.dart';
import 'views/welcome.dart';
import 'views/splash.dart';

// https://www.behance.net/gallery/81589609/Food-App
void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primaryColor: Color(0xff4e49ff),
      backgroundColor: Colors.white,
      primaryTextTheme: TextTheme(bodyText1: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
      textTheme: TextTheme(bodyText1: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
      fontFamily: 'Poppins',
//      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: Splash(),
//    home: Home(),
  ));
}