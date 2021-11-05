import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_styles.dart';


final ButtonStyle redElevatedButton =
    ElevatedButton.styleFrom(onPrimary: Colors.white, primary: Colors.red);

var mainTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: myTextTheme,
  primaryTextTheme: myTextTheme,
  dividerColor: grey500,
  // outlined button
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: orangeBlaze,
      onSurface: orangeBlaze,
      side: const BorderSide(
        width: 2.0,
        color: orangeBlaze,
        style: BorderStyle.solid,
      ),
    ),
  ),
  // elevated button
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: orangeBlaze,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    ),
  ),
  // navigation
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: orangeBlaze,
    unselectedItemColor: grey400,
  ),
  // floating action button
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: orangeBlaze,
    foregroundColor: Colors.white,
  ),
  // CheckBox
  unselectedWidgetColor: orangeBlaze,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
);
