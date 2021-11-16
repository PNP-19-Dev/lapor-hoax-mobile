/*
 * Created by andii on 16/11/21 22.37
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 21.07
 */

import 'package:laporhoax/utils/datetime_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  late final Future<SharedPreferences> sharedPreferences;
  static PreferencesHelper? _instance;

  PreferencesHelper.getInstance() {
    _instance = this;
    sharedPreferences = SharedPreferences.getInstance();
  }

  factory PreferencesHelper() => _instance ?? PreferencesHelper.getInstance();

  static const LOGIN = 'LOGIN';
  static const EXPIRE = 'EXPIRE';
  static const TOKEN = 'TOKEN';
  static const ID = 'ID';
  static const EMAIL = 'EMAIL';
  static const USERNAME = 'USERNAME';
  static const DARK_MODE = 'DARK_MODE';

  Future<String> get expireDate async {
    final prefs = await sharedPreferences;
    return prefs.getString(EXPIRE) ?? '';
  }

  void setExpire({String? value}) async {
    final prefs = await sharedPreferences;
    prefs.setString(EXPIRE, value ?? '');
  }

  Future<String> get token async {
    final prefs = await sharedPreferences;
    return prefs.getString(TOKEN) ?? '';
  }

  void setToken({String? value}) async {
    final prefs = await sharedPreferences;
    prefs.setString(TOKEN, value ?? '');
  }

  Future<String> get email async {
    final prefs = await sharedPreferences;
    return prefs.getString(EMAIL) ?? '';
  }

  void setEmail({String? value}) async {
    final prefs = await sharedPreferences;
    prefs.setString(EMAIL, value ?? '');
  }

  Future<int> get id async {
    final prefs = await sharedPreferences;
    return prefs.getInt(ID) ?? -1;
  }

  void setId({int? value}) async {
    final prefs = await sharedPreferences;
    prefs.setInt(ID, value ?? -1);
  }

  get username async {
    final prefs = await sharedPreferences;
    return prefs.getString(USERNAME) ?? '';
  }

  void setUsername({String? value}) async {
    final prefs = await sharedPreferences;
    prefs.setString(USERNAME, value ?? '');
  }

  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;

    final expire = prefs.getString(EXPIRE) ?? '';
    if (expire.isNotEmpty &&
        DateTime.now().isAfter(DateTimeHelper.formattedDateToken(expire))) {
      setExpire();
      setLogin(false);
      return false;
    }

    return prefs.getBool(LOGIN) ?? false;
  }

  void setLogin(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(LOGIN, value);
  }

  Future<bool> get isDark async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DARK_MODE) ?? false;
  }

  void setDark(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DARK_MODE, value);
  }
}
