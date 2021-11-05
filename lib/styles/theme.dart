import 'package:flutter/material.dart';
import 'package:laporhoax/styles/text_styles.dart';

import 'colors.dart';

final ButtonStyle redElevatedButton =
    ElevatedButton.styleFrom(onPrimary: Colors.white, primary: Colors.red);

final mainTheme = ThemeData.light().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: myTextTheme,
  colorScheme: kColorScheme,
  primaryColor: orangeBlaze,
  primaryTextTheme: myTextTheme,
  scaffoldBackgroundColor: Colors.white,
  dividerColor: grey500,
);