import 'package:flutter/material.dart';
import 'package:laporhoax/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lapor Hoax',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
      }
    );
  }
}

