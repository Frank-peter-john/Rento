import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  hoverColor: Colors.transparent,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.black),
  dividerColor: Colors.grey,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  hoverColor: Colors.transparent,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.black,
  iconTheme: const IconThemeData(color: Colors.white),
  dividerColor: Colors.grey,
);
