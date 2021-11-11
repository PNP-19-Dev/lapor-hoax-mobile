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

  Future<String> get expireDate async {
    final prefs = await sharedPreferences;
    return prefs.getString(EXPIRE) ?? '';
  }

  void setExpire(String? value) async {
    final prefs = await sharedPreferences;
    prefs.setString(EXPIRE, value ?? '');
  }

  Future<String> get token async {
    final prefs = await sharedPreferences;
    return prefs.getString(TOKEN) ?? '';
  }

  void setToken(String? value) async {
    final prefs = await sharedPreferences;
    prefs.setString(TOKEN, value ?? '');
  }

  Future<String> get email async {
    final prefs = await sharedPreferences;
    return prefs.getString(EMAIL) ?? '';
  }

  void setEmail(String? value) async {
    final prefs = await sharedPreferences;
    prefs.setString(EMAIL, value ?? '');
  }

  Future<int> get id async {
    final prefs = await sharedPreferences;
    return prefs.getInt(ID) ?? -1;
  }

  void setId(int value) async {
    final prefs = await sharedPreferences;
    prefs.setInt(ID, value);
  }

  get username async {
    final prefs = await sharedPreferences;
    return prefs.getString(USERNAME) ?? '';
  }

  void setUsername(String? value) async {
    final prefs = await sharedPreferences;
    prefs.setString(USERNAME, value ?? '');
  }

  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;

    final token = prefs.getString(TOKEN) ?? '';
    if (token.isNotEmpty &&
        DateTime.now().isAfter(DateTimeHelper.formattedDateToken(token))) {
      setExpire(null);
      setLogin(false);
      return false;
    }

    return prefs.getBool(LOGIN) ?? false;
  }

  void setLogin(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(LOGIN, value);
  }
}
