import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/injection.dart' as di;
import 'package:laporhoax/presentation/pages/home_page.dart';
import 'package:laporhoax/presentation/provider/feed_notifier.dart';
import 'package:laporhoax/presentation/provider/report_notifier.dart';
import 'package:laporhoax/presentation/provider/saved_feed_notifier.dart';
import 'package:laporhoax/presentation/provider/user_notifier.dart';
import 'package:laporhoax/util/route/routes.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print('MESSAGE: ${message.data}');
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<FeedNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SavedFeedNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<ReportNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<UserNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Lapor Hoax',
        theme: mainTheme,
        themeMode: ThemeMode.light,
        navigatorKey: navigatorKey,
        initialRoute: HomePage.routeName,
        routes: routes,
      ),
    );
  }
}
