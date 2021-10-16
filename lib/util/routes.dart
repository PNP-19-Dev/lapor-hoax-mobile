import 'package:flutter/material.dart';
import 'package:laporhoax/data/model/token_id.dart';
import 'package:laporhoax/data/model/user_report.dart';
import 'package:laporhoax/ui/account/account_profile.dart';
import 'package:laporhoax/ui/account/forgot_password_page.dart';
import 'package:laporhoax/ui/account/login_page.dart';
import 'package:laporhoax/ui/account/register_page.dart';
import 'package:laporhoax/ui/account/static_page_viewer.dart';
import 'package:laporhoax/ui/account/tutorial.dart';
import 'package:laporhoax/ui/account/user_challenge.dart';
import 'package:laporhoax/ui/home_page.dart';
import 'package:laporhoax/ui/news/news_web_view.dart';
import 'package:laporhoax/ui/news/saved_news.dart';
import 'package:laporhoax/ui/report/detail_report_page.dart';
import 'package:laporhoax/ui/report/history_page.dart';
import 'package:laporhoax/ui/report/on_loading_report.dart';
import 'package:laporhoax/ui/report/report_page.dart';
import 'package:laporhoax/util/static_data_web.dart';

Map<String, Widget Function(BuildContext)> routes = {
  HomePage.routeName: (context) => HomePage(),
  LoginPage.routeName: (context) => LoginPage(),
  ForgotPassword.routeName: (context) => ForgotPassword(),
  ForgotPasswordAction.routeName: (context) => ForgotPasswordAction(),
  RegisterPage.routeName: (context) => RegisterPage(),
  UserChallenge.routeName: (context) => UserChallenge(
        id: ModalRoute.of(context)?.settings.arguments as String,
      ),
  AccountProfile.routeName: (context) => AccountProfile(),
  HistoryPage.routeName: (context) => HistoryPage(
        tokenId: ModalRoute.of(context)?.settings.arguments as TokenId,
      ),
  ReportPage.routeName: (context) => ReportPage(),
  OnSuccessReport.routeName: (context) => OnSuccessReport(
        reportItem: ModalRoute.of(context)?.settings.arguments as ReportItem,
      ),
  OnFailureReport.routeName: (context) => OnFailureReport(),
  DetailReportPage.routeName: (context) => DetailReportPage(
        reportItem: ModalRoute.of(context)?.settings.arguments as ReportItem,
      ),
  NewsWebView.routeName: (context) =>
      NewsWebView(id: ModalRoute.of(context)?.settings.arguments as String),
  SavedNews.routeName: (context) => SavedNews(),
  StaticPageViewer.routeName: (context) => StaticPageViewer(
        data: ModalRoute.of(context)?.settings.arguments as StaticDataWeb,
      ),
  Tutorial.routeName: (context) => Tutorial(),
};
