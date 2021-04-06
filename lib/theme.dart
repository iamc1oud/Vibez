import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        fontFamily: "ProductSans",
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white,
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(fontFamily: "ProductSans");
  }
}
