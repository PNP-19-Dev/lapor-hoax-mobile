import 'package:laporhoax/data/model/user_data.dart';
import 'package:laporhoax/data/model/user_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const DARK_THEME = 'DARK_THEME'; // coming soon for dark theme
  static const LOGIN = 'LOGIN';
  static const SESSION = 'SESSION';
  static const DATA = 'DATA';

  Future<bool> get isDarkTheme async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DARK_THEME) ?? false;
  }

  void setDarkTheme(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DARK_THEME, value);
  }

  Future<List<String>> get sessionData async {
    final prefs = await sharedPreferences;
    return prefs.getStringList(SESSION) ?? [];
  }

  void setSessionData(UserToken value) async {
    final prefs = await sharedPreferences;
    if (value.expiry != null && value.token != null) {
      prefs.setStringList(SESSION, [value.expiry!, value.token!]);
    } else {
      prefs.setStringList(SESSION, []);
    }
  }

  Future<List<String>> get userData async {
    final prefs = await sharedPreferences;
    return prefs.getStringList(DATA) ?? [];
  }

  void setUserData(User data) async {
    final prefs = await sharedPreferences;
    if (data.id != -1) {
      prefs
          .setStringList(DATA, [data.id.toString(), data.username, data.email]);
    } else {
      prefs.setStringList(DATA, []);
    }
  }

  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;
    return prefs.getBool(LOGIN) ?? false;
  }

  void setLogin(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(LOGIN, value);
  }
}
