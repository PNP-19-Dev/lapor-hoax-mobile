/*
 * Created by andii on 15/11/21 13.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 15/11/21 12.55
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/profile_page.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/provider/profile_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockLoginCubit bloc;
  late MockProfileCubit profileCubit;

  setUp(() {
    bloc = MockLoginCubit();
    profileCubit = MockProfileCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>.value(value: bloc),
        BlocProvider<ProfileCubit>.value(value: profileCubit),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display register page items',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(LoginSuccessWithData(testSessionData));
    when(bloc.stream)
        .thenAnswer((_) => Stream.value(LoginSuccessWithData(testSessionData)));

    when(profileCubit.state).thenReturn(ProfileDataFetched(testUser));;
    when(profileCubit.stream)
        .thenAnswer((_) => Stream.value(ProfileDataFetched(testUser)));

    await tester.pumpWidget(_makeTestableWidget(ProfilePage(
      email: testSessionData.email,
    )));

    final texts = find.byType(Text);
    expect(texts, findsNWidgets(7));

    final inputs = find.byType(TextFormField);
    expect(inputs, findsNWidgets(2));

    final textButton = find.byType(InkWell);
    expect(textButton, findsNWidgets(2));
  });
}
