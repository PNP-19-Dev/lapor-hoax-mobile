import 'package:flutter/cupertino.dart';
import 'package:laporhoax/ui/account/forgot_password_page.dart';
import 'package:laporhoax/ui/account/login_page.dart';
import 'package:laporhoax/ui/account/register_page.dart';
import 'package:laporhoax/ui/home_page.dart';
import 'package:laporhoax/ui/report/history_page.dart';

Map<String, Widget Function(BuildContext)> routes = {
  HomePage.routeName: (context) => HomePage(),
  LoginPage.routeName: (context) => LoginPage(),
  ForgotPassword.routeName: (context) => ForgotPassword(),
  RegisterPage.routeName: (context) => RegisterPage(),
  HistoryPage.routeName: (context) => HistoryPage(),
};
