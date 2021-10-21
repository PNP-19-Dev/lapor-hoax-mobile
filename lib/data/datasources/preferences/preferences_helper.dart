import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/entities/user.dart';
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
  static const SESSION = 'SESSION';
  static const DATA = 'DATA';
  static const TOKEN = 'TOKEN';

  Future<List<String>> get sessionData async {
    final prefs = await sharedPreferences;
    return prefs.getStringList(SESSION) ?? [];
  }

  Future<String> setSessionData(UserToken value) async {
    final prefs = await sharedPreferences;
    if (value.expiry != null && value.token != null) {
      prefs.setStringList(SESSION, [value.expiry!, value.token!]);
      return 'Success';
    } else {
      prefs.setStringList(SESSION, []);
      return 'Removed!';
    }
  }

  Future<List<String>> get userData async {
    final prefs = await sharedPreferences;
    return prefs.getStringList(DATA) ?? [];
  }

  Future<String> setUserData(User data) async {
    final prefs = await sharedPreferences;
    if (data.id != -1) {
      prefs
          .setStringList(DATA, [data.id.toString(), data.username, data.email]);
      return 'Success';
    } else {
      prefs.setStringList(DATA, []);
      return 'Removed!';
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
