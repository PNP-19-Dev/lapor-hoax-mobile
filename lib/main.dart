import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/injection.dart' as di;
import 'package:laporhoax/presentation/pages/account/forgot_password_page.dart';
import 'package:laporhoax/presentation/pages/account/login_page.dart';
import 'package:laporhoax/presentation/pages/account/password_change_page.dart';
import 'package:laporhoax/presentation/pages/account/profile_page.dart';
import 'package:laporhoax/presentation/pages/account/register_page.dart';
import 'package:laporhoax/presentation/pages/account/tutorial_page.dart';
import 'package:laporhoax/presentation/pages/account/user_challenge.dart';
import 'package:laporhoax/presentation/pages/home_page.dart';
import 'package:laporhoax/presentation/pages/news/news_web_view.dart';
import 'package:laporhoax/presentation/pages/news/saved_news.dart';
import 'package:laporhoax/presentation/pages/report/detail_report_page.dart';
import 'package:laporhoax/presentation/pages/report/history_page.dart';
import 'package:laporhoax/presentation/pages/report/on_loading_report.dart';
import 'package:laporhoax/presentation/pages/report/report_page.dart';
import 'package:laporhoax/presentation/provider/feed_notifier.dart';
import 'package:laporhoax/presentation/provider/news_detail_notifier.dart';
import 'package:laporhoax/presentation/provider/question_notifier.dart';
import 'package:laporhoax/presentation/provider/report_notifier.dart';
import 'package:laporhoax/presentation/provider/saved_news_notifier.dart';
import 'package:laporhoax/presentation/provider/user_notifier.dart';
import 'package:laporhoax/util/static_data_web.dart';
import 'package:laporhoax/util/static_page_viewer.dart';
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
                final id = settings.arguments as int;
                return NewsWebView(id: id);
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
