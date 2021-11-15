/*
 * Created by andii on 15/11/21 12.51
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 15.51
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/forgot_password_page.dart';
import 'package:laporhoax/presentation/provider/password_cubit.dart';
import 'package:laporhoax/presentation/provider/question_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockPasswordCubit passwordCubit;
  late MockQuestionCubit questionCubit;

  setUp(() {
    passwordCubit = MockPasswordCubit();
    questionCubit = MockQuestionCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PasswordCubit>.value(value: passwordCubit),
        BlocProvider<QuestionCubit>.value(value: questionCubit),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display forgot section one',
          (WidgetTester tester) async {
        when(passwordCubit.state).thenReturn(PasswordInitial());
        when(passwordCubit.stream).thenAnswer((_) => const Stream.empty());

        await tester.pumpWidget(_makeTestableWidget(ForgotPasswordSectionOne()));

        final picture = find.byType(SvgPicture);
        expect(picture, findsOneWidget);

        final text = find.byType(Text);
        expect(text, findsNWidgets(4));

        final editText = find.byType(TextFormField);
        expect(editText, findsOneWidget);

        final button = find.byType(ElevatedButton);
        expect(button, findsOneWidget);
      });

  testWidgets('Page should display forgot section two',
          (WidgetTester tester) async {
        when(questionCubit.state).thenReturn(
          QuestionHasData(
              [testQuestion],
              QuestionCubit.questionToMap([testQuestion]),
              QuestionCubit.getIndexQuestion(testUserChallenge),
              QuestionCubit.getAnswerQuestion(testUserChallenge)),
        );
        when(questionCubit.stream).thenAnswer((_) => Stream.value(
          QuestionHasData(
              [testQuestion],
              QuestionCubit.questionToMap([testQuestion]),
              QuestionCubit.getIndexQuestion(testUserChallenge),
              QuestionCubit.getAnswerQuestion(testUserChallenge)),
        ));

        await tester.pumpWidget(
            _makeTestableWidget(ForgotPasswordSectionTwo(user: testUser)));

        final text = find.byType(Text);
        expect(text, findsNWidgets(6));

        final editText = find.byType(TextField);
        expect(editText, findsNWidgets(2));

        final button = find.byType(ElevatedButton);
        expect(button, findsOneWidget);
      });
}
