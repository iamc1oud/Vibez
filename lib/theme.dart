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
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all(TextStyle()),
                backgroundColor:
                    MaterialStateProperty.all(Colors.transparent))),
        textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.white,
            ),
            headline1: baseTextTheme,
            headline2: baseTextTheme,
            headline3: baseTextTheme,
            headline4: baseTextTheme,
            headline5: baseTextTheme,
            headline6: baseTextTheme),
        scaffoldBackgroundColor: darkScaffold,
        primaryColor: Colors.white);
  }

  static TextStyle get baseTextTheme => TextStyle(
        color: Colors.white,
      );

  static Color darkScaffold = Color(0xFF1b262c);
}
