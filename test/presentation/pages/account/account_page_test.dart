/*
 * Created by andii on 17/11/21 00.28
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 23.11
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/account_page.dart';
import 'package:laporhoax/presentation/provider/account_cubit.dart';
import 'package:laporhoax/presentation/provider/dark_provider.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockAccountCubit bloc;
  late MockLoginCubit loginBloc;
  late MockDarkProvider darkProvider;

  setUp(() {
    bloc = MockAccountCubit();
    loginBloc = MockLoginCubit();
    darkProvider = MockDarkProvider();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        BlocProvider<AccountCubit>.value(value: bloc),
        BlocProvider<LoginCubit>.value(value: loginBloc),
        ChangeNotifierProvider<DarkProvider>.value(value: darkProvider),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should welcome when not login',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(AccountNotLogin());
    when(bloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(AccountPage()));

    final finder = find.byKey(Key('account_page_logout'));
    expect(finder, findsOneWidget);
  });

  testWidgets('Page should display account menu when user is logged in',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(AccountLogin(testSessionData));
    when(bloc.stream)
        .thenAnswer((_) => Stream.value(AccountLogin(testSessionData)));

    when(loginBloc.state).thenReturn(LoginSuccessWithData(testSessionData));
    when(loginBloc.stream)
        .thenAnswer((_) => Stream.value(LoginSuccessWithData(testSessionData)));

    when(darkProvider.isDarkTheme).thenReturn(false);

    await tester.pumpWidget(_makeTestableWidget(AccountPage()));

    final finder = find.byKey(Key('account_page_login'));
    expect(finder, findsOneWidget);
  });
}
