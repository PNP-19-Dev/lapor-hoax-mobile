/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/remove_session_data.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';
import 'package:laporhoax/presentation/pages/home_page.dart';
import 'package:laporhoax/presentation/provider/feed_cubit.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_page_test.mocks.dart';

@GenerateMocks([
  GetFeeds,
  PostLogin,
  GetUser,
  SaveSessionData,
  GetSessionData,
  RemoveSessionData,
])
void main() {
  late MockGetFeeds _feeds;
  late MockPostLogin _login;
  late MockGetUser _user;
  late MockSaveSessionData _save;
  late MockGetSessionData _data;
  late MockRemoveSessionData _logout;

  setUp((){
    _feeds = MockGetFeeds();
    _login = MockPostLogin();
    _user = MockGetUser();
    _save = MockSaveSessionData();
    _data = MockGetSessionData();
    _logout = MockRemoveSessionData();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        Provider<FeedCubit>(
          create: (_) => FeedCubit(_feeds),
        ),
        Provider<LoginCubit>(
          create: (_) => LoginCubit(_login, _user, _save, _data, _logout),
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(_feeds.execute()).thenAnswer((_) async => Right([testFeed]));
        await tester.pumpWidget(_makeTestableWidget(HomePage()));

        final homeFinder = find.byKey(Key("home_page_scaffold"));
        expect(homeFinder, findsOneWidget);
      });
}
