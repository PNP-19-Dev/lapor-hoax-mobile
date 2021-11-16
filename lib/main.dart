/*
 * Created by andii on 16/11/21 01.03
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 00.14
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/firebase_impl.dart' as fire;
import 'package:laporhoax/injection.dart' as di;
import 'package:laporhoax/presentation/pages/account/account_page.dart';
import 'package:laporhoax/presentation/pages/account/change_user_question.dart';
import 'package:laporhoax/presentation/pages/account/forgot_password_page.dart';
import 'package:laporhoax/presentation/pages/account/login_page.dart';
import 'package:laporhoax/presentation/pages/account/on_register_success.dart';
import 'package:laporhoax/presentation/pages/account/password_change_page.dart';
import 'package:laporhoax/presentation/pages/account/profile_page.dart';
import 'package:laporhoax/presentation/pages/account/register_page.dart';
import 'package:laporhoax/presentation/pages/account/user_challenge.dart';
import 'package:laporhoax/presentation/pages/home_page.dart';
import 'package:laporhoax/presentation/pages/news/news_web_view.dart';
import 'package:laporhoax/presentation/pages/news/saved_news.dart';
import 'package:laporhoax/presentation/pages/report/detail_report_page.dart';
import 'package:laporhoax/presentation/pages/report/history_page.dart';
import 'package:laporhoax/presentation/pages/report/on_loading_report.dart';
import 'package:laporhoax/presentation/pages/report/report_page.dart';
import 'package:laporhoax/presentation/pages/static/about_page.dart';
import 'package:laporhoax/presentation/pages/static/static_page_viewer.dart';
import 'package:laporhoax/presentation/pages/static/tutorial_page.dart';
import 'package:laporhoax/presentation/provider/about_cubit.dart';
import 'package:laporhoax/presentation/provider/account_cubit.dart';
import 'package:laporhoax/presentation/provider/detail_cubit.dart';
import 'package:laporhoax/presentation/provider/feed_cubit.dart';
import 'package:laporhoax/presentation/provider/history_cubit.dart';
import 'package:laporhoax/presentation/provider/item_cubit.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/provider/password_cubit.dart';
import 'package:laporhoax/presentation/provider/profile_cubit.dart';
import 'package:laporhoax/presentation/provider/question_cubit.dart';
import 'package:laporhoax/presentation/provider/register_cubit.dart';
import 'package:laporhoax/presentation/provider/report_cubit.dart';
import 'package:laporhoax/presentation/provider/saved_feed_cubit.dart';
import 'package:laporhoax/styles/theme.dart';
import 'package:laporhoax/utils/navigation.dart';
import 'package:laporhoax/utils/route_observer.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  fire.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<FeedCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SavedFeedCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<ReportCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PasswordCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<QuestionCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<HistoryCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<ItemCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<LoginCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<AccountCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<RegisterCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<AboutCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<ProfileCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Lapor Hoax',
        theme: mainTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        navigatorKey: navigatorKey,
        home: HomePage(),
        navigatorObservers: [routeObserver],
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
              return MaterialPageRoute(
                  builder: (_) => ReportPage(key: Key('report_page')));
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
            case About.routeName:
              return MaterialPageRoute(builder: (_) => About());
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
