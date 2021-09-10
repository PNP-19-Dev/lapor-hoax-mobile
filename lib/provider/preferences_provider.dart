import 'package:flutter/material.dart';
import 'package:laporhoax/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getLoginData();
    _getSessionData();
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  String _loginData = "";

  String get loginData => _loginData;

  void _getSessionData() async {
    _loginData = await preferencesHelper.sessionData;
    notifyListeners();
  }

  void _getLoginData() async {
    _isLoggedIn = await preferencesHelper.isLogin;
    notifyListeners();
  }
}
