/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.53
 */

import 'package:flutter/material.dart';
import 'package:laporhoax/styles/text_styles.dart';

import 'colors.dart';

final ButtonStyle redElevatedButton =
    ElevatedButton.styleFrom(onPrimary: Colors.white, primary: Colors.red);

final mainTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: myTextTheme,
  colorScheme: kColorLightScheme,
  scaffoldBackgroundColor: Colors.white,
  dividerColor: grey500,
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);

final darkTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: myTextTheme,
  colorScheme: kColorDarkScheme,
  primaryColor: orangeBlaze,
  primaryTextTheme: myTextTheme,
  scaffoldBackgroundColor: Colors.black,
  dividerColor: grey500,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: Colors.black,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
  ),
);