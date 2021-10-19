import 'package:flutter/material.dart';
import 'package:laporhoax/data/datasources/preferences/preferences_helper.dart';
import 'package:laporhoax/data/models/user_data.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/util/datetime_helper.dart';

class PreferencesNotifier extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesNotifier({required this.preferencesHelper}) {
    _getSessionData();
    _getUserData();
    _getLoginData();
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  late UserToken _loginData;
  late User _userData;

  User get userData => _userData;

  UserToken get loginData => _loginData;

  void _getSessionData() async {
    List<String> dataArray = await preferencesHelper.sessionData;
    _loginData = dataArray.isNotEmpty
        ? UserToken(expiry: dataArray[0], token: dataArray[1])
        : UserToken.empty();
    notifyListeners();
  }

  void _getLoginData() async {
    _isLoggedIn = await preferencesHelper.isLogin;
    if (_loginData.expiry != null) {
      if (DateTime.now()
          .isAfter(DateTimeHelper.formattedDateToken(_loginData.expiry!))) {
        setSessionData(UserToken.empty());
        setUserData(User.empty());
      }
    }
    notifyListeners();
  }

  void _getUserData() async {
    List<String> dataArray = await preferencesHelper.userData;
    _userData = dataArray.isNotEmpty
        ? User(
            id: int.parse(dataArray[0]),
            username: dataArray[1],
            email: dataArray[2])
        : User.empty();
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

  void setUserData(User data) {
    preferencesHelper.setUserData(data);
    _getUserData();
  }
}
