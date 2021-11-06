import 'package:flutter/material.dart';

const Color grey100 = Color(0x33C4C4C4);
const Color grey200 = Color(0xFFBDBDBD);
const Color grey300 = Color(0xFFBABABA);
const Color grey400 = Color(0xFFA6A6A6);
const Color grey500 = Color(0xFF979797);
const Color grey600 = Color(0xFF7C7C7C);
const Color grey700 = Color(0xFF595959);
const Color orange200 = Color(0xFFFFE2CC);
const Color orangeBlaze = Color(0xFFF96C00);
const Color orangeBlazeVariant = Color(0xFFE35802);
const Color failure = Color(0xFFFF3333);
const Color success = Color(0xFF4BB543);

const kColorScheme = ColorScheme(
  // most frequently used color
  primary: orangeBlaze,
  // darker color of primary
  primaryVariant: orangeBlazeVariant,
  // accent color
  secondary: orangeBlaze,
  // darker version of secondary
  secondaryVariant: orangeBlazeVariant,
  // background color for card
  surface: Colors.grey,
  // color appear behind scrollable content
  background: Colors.white,
  // color for input validation error
  error: failure,
  // color drawn on primary
  onPrimary: Colors.white,
  // color drawn on secondary
  onSecondary: Colors.white,
  // color drawn on surface
  onSurface: Colors.black,
  // color drawn on background
  onBackground: Colors.black,
  // color drawn on error
  onError: Colors.white,
  // overall brightness
  brightness: Brightness.light,
);