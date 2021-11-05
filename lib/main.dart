import 'package:core/core.dart';
import 'package:feed/feed.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laporhoax/injection.dart' as di;
import 'package:provider/provider.dart';

import 'home_page.dart';

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
  await FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: "312A80DA-78AF-4315-BF63-33DB9B315F4A");
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
          create: (_) => di.locator<NewsDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SavedNewsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<ReportNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<UserNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<QuestionNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Lapor Hoax',
        theme: mainTheme,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        navigatorKey: navigatorKey,
        home: HomePage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomePage());
            case LoginPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => LoginPage());
            case ForgotPasswordSectionOne.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => ForgotPasswordSectionOne());
            case ForgotPasswordSectionTwo.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) {
                final user = settings.arguments as User;
                return ForgotPasswordSectionTwo(user: user);
              });
            case PasswordChangePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => PasswordChangePage());
            case RegisterPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => RegisterPage());
            case UserChallenge.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) {
                final id = settings.arguments as int;
                return UserChallenge(id: id);
              });
            case ChangeUserQuestion.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) {
                final id = settings.arguments as int;
                return ChangeUserQuestion(id: id);
              });
            case ProfilePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) {
                final email = settings.arguments as String;
                return ProfilePage(email: email);
              });
            case HistoryPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) {
                final tokenId = settings.arguments as TokenId;
                return HistoryPage(tokenId: tokenId);
              });
            case ReportPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => ReportPage());
            case OnSuccessReport.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) {
                final reportItem = settings.arguments as Report;
                return OnSuccessReport(
                  reportItem: reportItem,
                );
              });
            case OnFailureReport.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => OnFailureReport());
            case DetailReportPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) {
                final report = settings.arguments as Report;
                return DetailReportPage(report: report);
              });
            case NewsWebView.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) {
                final data = settings.arguments as int;
                return NewsWebView(id: data);
              });
            case SavedNews.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => SavedNews());
            case StaticPageViewer.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) {
                final data = settings.arguments as StaticDataWeb;
                return StaticPageViewer(data: data);
              });
            case TutorialPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TutorialPage());
            case OnRegisterSuccess.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => OnRegisterSuccess(
                        settings.arguments as String,
                      ));
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
