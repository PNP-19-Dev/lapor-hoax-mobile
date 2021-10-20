import 'package:flutter/material.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/presentation/pages/account/account_profile.dart';
import 'package:laporhoax/presentation/pages/account/forgot_password_page.dart';
import 'package:laporhoax/presentation/pages/account/login_page.dart';
import 'package:laporhoax/presentation/pages/account/password_change_page.dart';
import 'package:laporhoax/presentation/pages/account/register_page.dart';
import 'package:laporhoax/presentation/pages/account/static_page_viewer.dart';
import 'package:laporhoax/presentation/pages/account/tutorial.dart';
import 'package:laporhoax/presentation/pages/account/user_challenge.dart';
import 'package:laporhoax/presentation/pages/home_page.dart';
import 'package:laporhoax/presentation/pages/news/news_web_view.dart';
import 'package:laporhoax/presentation/pages/news/saved_news.dart';
import 'package:laporhoax/presentation/pages/report/detail_report_page.dart';
import 'package:laporhoax/presentation/pages/report/history_page.dart';
import 'package:laporhoax/presentation/pages/report/on_loading_report.dart';
import 'package:laporhoax/presentation/pages/report/report_page.dart';
import 'package:laporhoax/util/route/challenge_arguments.dart';
import 'package:laporhoax/util/static_data_web.dart';

Map<String, Widget Function(BuildContext)> routes = {
  HomePage.routeName: (context) => HomePage(),
  LoginPage.routeName: (context) => LoginPage(),
  ForgotPasswordSectionOne.routeName: (context) => ForgotPasswordSectionOne(),
  ForgotPasswordSectionTwo.routeName: (context) {
    ChallengeArguments args =
        ModalRoute.of(context)?.settings.arguments as ChallengeArguments;
    return ForgotPasswordSectionTwo(
      user: args.user,
      challenge: args.challenge,
    );
  },
  PasswordChangePage.routeName: (context) => PasswordChangePage(),
  RegisterPage.routeName: (context) => RegisterPage(),
  UserChallenge.routeName: (context) => UserChallenge(
        id: ModalRoute.of(context)?.settings.arguments as int,
      ),
  AccountProfile.routeName: (context) => AccountProfile(),
  HistoryPage.routeName: (context) => HistoryPage(
        tokenId: ModalRoute.of(context)?.settings.arguments as TokenId,
      ),
  ReportPage.routeName: (context) => ReportPage(),
  OnSuccessReport.routeName: (context) => OnSuccessReport(
        reportItem: ModalRoute.of(context)?.settings.arguments as Report,
      ),
  OnFailureReport.routeName: (context) => OnFailureReport(),
  DetailReportPage.routeName: (context) => DetailReportPage(
        reportItem: ModalRoute.of(context)?.settings.arguments as Report,
      ),
  NewsWebView.routeName: (context) =>
      NewsWebView(feed: ModalRoute.of(context)?.settings.arguments as Feed),
  SavedNews.routeName: (context) => SavedNews(),
  StaticPageViewer.routeName: (context) => StaticPageViewer(
        data: ModalRoute.of(context)?.settings.arguments as StaticDataWeb,
      ),
  Tutorial.routeName: (context) => Tutorial(),
};
