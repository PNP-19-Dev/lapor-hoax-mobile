/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/user_challenge.dart';
import 'package:laporhoax/presentation/provider/question_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockQuestionCubit bloc;

  setUp(() {
    bloc = MockQuestionCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<QuestionCubit>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets("Page should display 'loading' text when loading",
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(QuestionLoading());
        when(bloc.stream).thenAnswer((_) => const Stream.empty());

        await tester.pumpWidget(_makeTestableWidget(UserChallenge(id: 1)));

        final finder = find.text('Loading');
        expect(finder, findsNWidgets(3));
      });
}
