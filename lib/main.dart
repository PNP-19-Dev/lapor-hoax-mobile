import 'package:flutter/material.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/ui/home_page.dart';
import 'package:laporhoax/util/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lapor Hoax',
      theme: mainTheme,
      navigatorKey: navigatorKey,
      initialRoute: HomePage.routeName,
      routes: routes,
    );
  }
}
