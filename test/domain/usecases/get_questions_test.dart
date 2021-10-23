import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/domain/usecases/get_questions.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetQuestions usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetQuestions(mockRepository);
  });

  final tQuestions = <Question>[];

  group('GetQuestions Test', () {
    group('execute', () {
      test('should get list of question when execute function is called',
          () async {
        // arrange
        when(mockRepository.getQuestions())
            .thenAnswer((_) async => Right(tQuestions));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tQuestions));
      });
    });
  });
}
