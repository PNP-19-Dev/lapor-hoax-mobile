/*
 * Created by andii on 16/11/21 22.37
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 22.05
 */

import 'package:flutter/material.dart';
import 'package:laporhoax/data/datasources/preferences/preferences_helper.dart';

class DarkProvider extends ChangeNotifier {
  PreferencesHelper _helper;

  DarkProvider(this._helper) {
    _getTheme();
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  void _getTheme() async {
    _isDarkTheme = await _helper.isDark;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    _helper.setDark(value);
    _getTheme();
  }
}
