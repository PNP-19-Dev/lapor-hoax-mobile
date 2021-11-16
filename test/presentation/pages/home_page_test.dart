/*
 * Created by andii on 16/11/21 09.46
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 08.26
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/remove_session_data.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';
import 'package:laporhoax/presentation/pages/account/account_page.dart';
import 'package:laporhoax/presentation/pages/home_page.dart';
import 'package:laporhoax/presentation/pages/news/news_page.dart';
import 'package:laporhoax/presentation/provider/account_cubit.dart';
import 'package:laporhoax/presentation/provider/feed_cubit.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/provider/report_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

@GenerateMocks([
  GetFeeds,
  PostLogin,
  GetUser,
  SaveSessionData,
  GetSessionData,
  RemoveSessionData,
])
void main() {
  late MockLoginCubit _loginCubit;
  late MockFeedCubit _feedCubit;
  late MockAccountCubit _accountCubit;
  late MockReportCubit _reportCubit;

  setUp(() {
    _loginCubit = MockLoginCubit();
    _feedCubit = MockFeedCubit();
    _accountCubit = MockAccountCubit();
    _reportCubit = MockReportCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedCubit>.value(value: _feedCubit),
        BlocProvider<LoginCubit>.value(value: _loginCubit),
        BlocProvider<AccountCubit>.value(value: _accountCubit),
        BlocProvider<ReportCubit>.value(value: _reportCubit),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display a bottom navigation bar components',
      (WidgetTester tester) async {
    when(_feedCubit.state).thenReturn(FeedHasData([testFeed]));
    when(_feedCubit.stream)
        .thenAnswer((_) => Stream.value(FeedHasData([testFeed])));

    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    final homeFinder = find.byKey(Key("home_page_scaffold"));
    expect(homeFinder, findsOneWidget);

    final navigationFinder = find.byKey(Key("bottom_bar"));
    expect(navigationFinder, findsOneWidget);

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Page should display news feeds', (WidgetTester tester) async {
    when(_feedCubit.state).thenReturn(FeedHasData([testFeed]));
    when(_feedCubit.stream)
        .thenAnswer((_) => Stream.value(FeedHasData([testFeed])));

    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    expect(find.byType(NewsPage), findsOneWidget);
  });

  testWidgets('Page should display account page when firstOpened [not login]',
      (WidgetTester tester) async {
    when(_feedCubit.state).thenReturn(FeedHasData([testFeed]));
    when(_feedCubit.stream)
        .thenAnswer((_) => Stream.value(FeedHasData([testFeed])));

    when(_accountCubit.state).thenReturn(AccountLogin(testSessionData));
    when(_accountCubit.stream)
        .thenAnswer((_) => Stream.value(AccountLogin(testSessionData)));

    when(_loginCubit.state).thenReturn(LoginSuccessWithData(testSessionData));
    when(_loginCubit.stream)
        .thenAnswer((_) => Stream.value(LoginSuccessWithData(testSessionData)));

    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    final homeFinder = find.byKey(Key("home_page_scaffold"));
    expect(homeFinder, findsOneWidget);

    final accountIcon = find.byIcon(FontAwesomeIcons.user);
    expect(accountIcon, findsOneWidget);

    await tester.tap(accountIcon);
    await tester.pump();

    expect(find.byType(AccountPage), findsOneWidget);
  });

  testWidgets('Page should display news page when clicked',
      (WidgetTester tester) async {
    when(_feedCubit.state).thenReturn(FeedHasData([testFeed]));
    when(_feedCubit.stream)
        .thenAnswer((_) => Stream.value(FeedHasData([testFeed])));

    when(_accountCubit.state).thenReturn(AccountLogin(testSessionData));
    when(_accountCubit.stream)
        .thenAnswer((_) => Stream.value(AccountLogin(testSessionData)));

    when(_loginCubit.state).thenReturn(LoginSuccessWithData(testSessionData));
    when(_loginCubit.stream)
        .thenAnswer((_) => Stream.value(LoginSuccessWithData(testSessionData)));

    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    final homeFinder = find.byKey(Key("home_page_scaffold"));
    expect(homeFinder, findsOneWidget);

    final accountIcon = find.byIcon(FontAwesomeIcons.user);
    expect(accountIcon, findsOneWidget);

    await tester.tap(accountIcon);
    await tester.pump();

    expect(find.byType(AccountPage), findsOneWidget);

    final newsIcon = find.byIcon(FontAwesomeIcons.newspaper);
    expect(newsIcon, findsOneWidget);

    await tester.tap(newsIcon);
    await tester.pump();

    expect(find.byType(NewsPage), findsOneWidget);
  });

  testWidgets('Page should display news feeds', (WidgetTester tester) async {
    when(_feedCubit.state).thenReturn(FeedHasData([testFeed]));
    when(_feedCubit.stream)
        .thenAnswer((_) => Stream.value(FeedHasData([testFeed])));

    when(_loginCubit.state).thenReturn(LoginSuccessWithData(testSessionData));
    when(_loginCubit.stream)
        .thenAnswer((_) => Stream.value(LoginSuccessWithData(testSessionData)));

    when(_reportCubit.state).thenReturn(ReportInitial());
    when(_reportCubit.stream)
        .thenAnswer((_) => Stream.empty());


    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    final fab = find.byKey(Key('fab_add_report'));

    expect(fab, findsOneWidget);

    await tester.tap(fab);
    await tester.pump();
  });
}
