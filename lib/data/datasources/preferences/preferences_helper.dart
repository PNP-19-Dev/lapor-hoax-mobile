import 'package:laporhoax/util/datetime_helper.dart';
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

  String? _expire;

  Future<String> get expireDate async {
    final prefs = await sharedPreferences;
    return prefs.getString(EXPIRE) ?? '';
  }

  void setExpire(String? value) async {
    final prefs = await sharedPreferences;
    _expire = value;
    prefs.setString(EXPIRE, value ?? '');
  }

  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;
    if (_expire != null) {
      if (DateTime.now().isAfter(DateTimeHelper.formattedDateToken(_expire!))) {
        setExpire(null);
        setLogin(false);
      }
      return prefs.getBool(EXPIRE) ?? false;
    }
    return prefs.getBool(LOGIN) ?? false;
  }

  void setLogin(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(LOGIN, value);
  }
}
