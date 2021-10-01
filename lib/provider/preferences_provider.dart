import 'package:flutter/material.dart';
import 'package:laporhoax/data/model/user_token.dart';
import 'package:laporhoax/data/preferences/preferences_helper.dart';
import 'package:laporhoax/util/datetime_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getSessionData();
    _getLoginData();
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  late UserToken _loginData;

  UserToken get loginData => _loginData;

  void _getSessionData() async {
    List<String> dataArray = await preferencesHelper.sessionData;
    _loginData = dataArray.isNotEmpty
        ? UserToken(expiry: dataArray[0], token: dataArray[1])
        : UserToken(expiry: null, token: null);
    notifyListeners();
  }

  void _getLoginData() async {
    _isLoggedIn = await preferencesHelper.isLogin;
    if (DateTimeHelper.formattedDateToken(_loginData.expiry) ==
        DateTime.now().toString()) {
      setSessionData(UserToken(expiry: null, token: null));
      notifyListeners();
    }
    notifyListeners();
  }

  void setSessionData(UserToken data) {
    preferencesHelper.setSessionData(data);
    data.token != null ? setLoginData(true) : setLoginData(false);
    _getSessionData();
  }

  void setLoginData(bool value) {
    preferencesHelper.setLogin(value);
    _getLoginData();
  }
}
