import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/domain/usecases/get_questions.dart';
import 'package:laporhoax/domain/usecases/get_user_challenge.dart';
import 'package:laporhoax/presentation/provider/question_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'question_notifier_test.mocks.dart';

@GenerateMocks([
  GetQuestions,
  GetUserChallenge,
])
void main() {
  late QuestionNotifier provider;
  late MockGetQuestions mockGetQuestions;
  late MockGetUserChallenge mockGetUserChallenge;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetQuestions = MockGetQuestions();
    mockGetUserChallenge = MockGetUserChallenge();
    provider = QuestionNotifier(
      getQuestions: mockGetQuestions,
      getUserChallenge: mockGetUserChallenge,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('On Success', () {
    test('should change questions data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetQuestions.execute())
          .thenAnswer((_) async => Right([testQuestion]));
      // act
      await provider.getQuestions;
      // assert
      expect(provider.questionState, RequestState.Loaded);
      expect(provider.question, [testQuestion]);
      expect(listenerCallCount, 2);
    });

    test('should get user questions data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetUserChallenge.execute(1))
          .thenAnswer((_) async => Right(testUserChallenge));
      // act
      await provider.getUserSecurityQuestion(1);
      // assert
      expect(provider.questionState, RequestState.Loaded);
      expect(provider.question, testUserChallenge);
      expect(listenerCallCount, 2);
    });
  });

  group('on Error', () {
    test('should return error when question data is unsuccessful', () async {
      // arrange
      when(mockGetQuestions.execute())
          .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      // act
      await provider.getQuestions;
      // assert
      expect(provider.questionState, RequestState.Error);
      expect(provider.questionMessage, "Server Failure");
      expect(listenerCallCount, 1);
    });

    test('should return error when user question data is unsuccessful',
        () async {
      // arrange
      when(mockGetUserChallenge.execute(1))
          .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      // act
      await provider.getUserSecurityQuestion(1);
      // assert
      expect(provider.questionState, RequestState.Error);
      expect(provider.questionMessage, "Server Failure");
      expect(listenerCallCount, 1);
    });
  });
}
