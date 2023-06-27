import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1CC1E4);
  static const Color secondary = Colors.yellow;
  static const Color scaffold = Color(0xFFFEFFFF);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: scaffold,
    appBarTheme: AppBarTheme(
      // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: primary),
      backgroundColor: primary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(
        color: white,
      ),
    ),
    iconTheme: IconThemeData(
      color: white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(black),
      backgroundColor: MaterialStateProperty.all(secondary),
    )),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondary),
  );
}
