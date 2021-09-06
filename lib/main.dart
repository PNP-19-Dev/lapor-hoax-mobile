import 'package:flutter/material.dart';
import 'package:laporhoax/ui/home_page.dart';
import 'package:laporhoax/ui/login_page.dart';
import 'package:laporhoax/ui/register_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lapor Hoax',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          LoginPage.routeName: (context) => LoginPage(),
          RegisterPage.routeName: (context) => RegisterPage(),
        });
  }
}

