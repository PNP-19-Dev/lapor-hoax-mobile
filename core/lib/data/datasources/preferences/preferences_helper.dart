import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/datetime_helper.dart';

class PreferencesHelper {
  late final Future<SharedPreferences> sharedPreferences;
  static PreferencesHelper? _instance;

  PreferencesHelper.getInstance() {
    _instance = this;
    sharedPreferences = SharedPreferences.getInstance();
  }

  factory PreferencesHelper() => _instance ?? PreferencesHelper.getInstance();

  static const login = 'LOGIN';
  static const expire = 'EXPIRE';
  static const tokenString = 'TOKEN';
  static const idData = 'ID';
  static const emailData = 'EMAIL';
  static const usernameData = 'USERNAME';

  Future<String> get expireDate async {
    final prefs = await sharedPreferences;
    return prefs.getString(expire) ?? '';
  }

  void setExpire(String? value) async {
    final prefs = await sharedPreferences;
    prefs.setString(expire, value ?? '');
  }

  Future<String> get token async {
    final prefs = await sharedPreferences;
    return prefs.getString(tokenString) ?? '';
  }

  void setToken(String? value) async {
    final prefs = await sharedPreferences;
    prefs.setString(tokenString, value ?? '');
  }

  Future<String> get email async {
    final prefs = await sharedPreferences;
    return prefs.getString(emailData) ?? '';
  }

  void setEmail(String? value) async {
    final prefs = await sharedPreferences;
    prefs.setString(emailData, value ?? '');
  }

  Future<int> get id async {
    final prefs = await sharedPreferences;
    return prefs.getInt(idData) ?? -1;
  }

  void setId(int value) async {
    final prefs = await sharedPreferences;
    prefs.setInt(idData, value);
  }

  get username async {
    final prefs = await sharedPreferences;
    return prefs.getString(usernameData) ?? '';
  }

  void setUsername(String? value) async {
    final prefs = await sharedPreferences;
    prefs.setString(usernameData, value ?? '');
  }

  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;
    final session = prefs.getString(expire) ?? '';
    if (session.isNotEmpty &&
        DateTime.now()
            .toUtc()
            .isAfter(DateTimeHelper.formattedDateToken(session)))
    {
      setExpire(null);
      setLogin(false);
      return false;
    }
    return prefs.getBool(login) ?? false;
  }

  void setLogin(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(login, value);
  }
}
