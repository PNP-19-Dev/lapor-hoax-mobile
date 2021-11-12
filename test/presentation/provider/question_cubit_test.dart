import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_questions.dart';
import 'package:laporhoax/domain/usecases/get_user_challenge.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';
import 'package:laporhoax/presentation/provider/question_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'question_cubit_test.mocks.dart';

@GenerateMocks([
  GetUserChallenge,
  GetQuestions,
  PostUserChallenge,
])
void main() {
  late QuestionCubit bloc;
  late MockGetQuestions _questions;
  late MockGetUserChallenge _challenge;
  late MockPostUserChallenge _send;

  setUp(() {
    _questions = MockGetQuestions();
    _challenge = MockGetUserChallenge();
    _send = MockPostUserChallenge();
    bloc = QuestionCubit(_challenge, _questions, _send);
  });

  group('Get Questions',(){
    blocTest<QuestionCubit, QuestionState>(
      'should get [only] question from usecase',
      build: () {
        when(_questions.execute()).thenAnswer((_) async => Right([testQuestion]));
        return bloc;
      },
      act: (cubit) => cubit.fetchQuestions(),
      verify: (cubit) => cubit.fetchQuestions(),
      expect: () => [
        QuestionLoading(),
        QuestionHasData.question([testQuestion]),
      ],
    );

    blocTest<QuestionCubit, QuestionState>(
      'should return error callback from usecase when data is unsuccessful',
      build: () {
        when(_questions.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        return bloc;
      },
      act: (cubit) => cubit.fetchQuestions(),
      verify: (cubit) => cubit.fetchQuestions(),
      expect: () => [
        QuestionLoading(),
        QuestionError('Failure'),
      ],
    );
  });

  group('Get User Challenge', (){
    const tId = 1;
    blocTest<QuestionCubit, QuestionState>(
      'should get question with user data from usecase',
      build: () {
        when(_questions.execute()).thenAnswer((_) async => Right([testQuestion]));
        when(_challenge.execute(tId))
            .thenAnswer((_) async => Right(testUserChallenge));
        return bloc;
      },
      act: (cubit) => cubit.fetchQuestionWithChallenge(tId),
      verify: (cubit) => cubit.fetchQuestionWithChallenge(tId),
      expect: () => [
        QuestionLoading(),
        QuestionHasData(
            [testQuestion],
            QuestionCubit.questionToMap([testQuestion]),
            QuestionCubit.getIndexQuestion(testUserChallenge),
            QuestionCubit.getAnswerQuestion(testUserChallenge)),
      ],
    );

    blocTest<QuestionCubit, QuestionState>(
      'should get question with user data from usecase',
      build: () {
        when(_questions.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        when(_challenge.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        return bloc;
      },
      act: (cubit) => cubit.fetchQuestionWithChallenge(tId),
      verify: (cubit) => cubit.fetchQuestionWithChallenge(tId),
      expect: () => [QuestionLoading(), QuestionError('Failure')],
    );
  });

  group('Send Challenge', () {
    blocTest<QuestionCubit, QuestionState>(
      'should return success callback when question has sent',
      build: () {
        when(_send.execute(testUserChallenge))
            .thenAnswer((_) async => Right('Success'));
        return bloc;
      },
      act: (cubit) => cubit.sendQuestions(testUserChallenge),
      verify: (cubit) => cubit.sendQuestions(testUserChallenge),
      expect: () => [
        ChallengeSending(),
        ChallengeSuccess(),
      ],
    );

    blocTest<QuestionCubit, QuestionState>(
      'should return error callback when question has sent',
      build: () {
        when(_send.execute(testUserChallenge))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        return bloc;
      },
      act: (cubit) => cubit.sendQuestions(testUserChallenge),
      verify: (cubit) => cubit.sendQuestions(testUserChallenge),
      expect: () => [
        ChallengeSending(),
        ChallengeError('Failure'),
      ],
    );
  });
}
