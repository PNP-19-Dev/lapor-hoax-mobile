import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/db/database_helper.dart';
import 'package:laporhoax/data/preferences/preferences_helper.dart';
import 'package:laporhoax/provider/database_provider.dart';
import 'package:laporhoax/provider/feed_provider.dart';
import 'package:laporhoax/provider/preferences_provider.dart';
import 'package:laporhoax/ui/home_page.dart';
import 'package:laporhoax/util/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FeedProvider(apiService: LaporhoaxApi(dio)),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                  sharedPreferences: SharedPreferences.getInstance())),
        ),
      ],
      child: MaterialApp(
        title: 'Lapor Hoax',
        theme: mainTheme,
        navigatorKey: navigatorKey,
        initialRoute: HomePage.routeName,
        routes: routes,
      ),
    );
  }
}
