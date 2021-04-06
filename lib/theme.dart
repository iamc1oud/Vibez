import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        fontFamily: "ProductSans",
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black54)),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white,
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        fontFamily: "ProductSans",
        iconTheme: IconThemeData(color: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
            fillColor: darkScaffold,
            hintStyle: baseDarkThemeTextStyle,
            labelStyle: baseDarkThemeTextStyle.copyWith(color: Colors.white)),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all(TextStyle()),
                backgroundColor:
                    MaterialStateProperty.all(Colors.transparent))),
        textTheme: TextTheme(
            bodyText1: baseDarkThemeTextStyle,
            headline1: baseDarkThemeTextStyle,
            headline2: baseDarkThemeTextStyle,
            headline3: baseDarkThemeTextStyle,
            headline4: baseDarkThemeTextStyle,
            headline5: baseDarkThemeTextStyle,
            headline6: baseDarkThemeTextStyle),
        scaffoldBackgroundColor: darkScaffold,
        primaryColor: Colors.white);
  }

  static TextStyle get baseDarkThemeTextStyle =>
      TextStyle(color: Colors.white, letterSpacing: 1.4);

  static Color darkScaffold = Color(0xFF121212);
}
