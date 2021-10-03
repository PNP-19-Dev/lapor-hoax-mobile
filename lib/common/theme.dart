import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color grey200 = Color(0xFFBDBDBD);
final Color grey300 = Color(0xFFBABABA);
final Color grey400 = Color(0xFFA6A6A6);
final Color grey500 = Color(0xFF979797);
final Color grey600 = Color(0xFF7C7C7C);
final Color orange200 = Color(0xFFFFE2CC);
final Color orangeBlaze = Color(0xFFF96C00);

final TextTheme myTextTheme = TextTheme(
  headline1: GoogleFonts.inter(
    fontSize: 93,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
  ),
  headline2: GoogleFonts.inter(
    fontSize: 58,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
  ),
  headline3: GoogleFonts.inter(fontSize: 47, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.25,
  ),
  headline5: GoogleFonts.inter(
    fontSize: 25,
    fontWeight: FontWeight.w400,
  ),
  headline6: GoogleFonts.inter(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.15,
  ),
  subtitle1: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      height: 0.5),
  bodyText1: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  ),
  caption: GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.inter(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

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
      side: BorderSide(
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    ),
  ),
  // navigation
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: orangeBlaze,
    unselectedItemColor: grey400,
  ),
  // floating action button
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: orangeBlaze,
    foregroundColor: Colors.white,
  ),
  // CheckBox
  unselectedWidgetColor: orangeBlaze,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
);
