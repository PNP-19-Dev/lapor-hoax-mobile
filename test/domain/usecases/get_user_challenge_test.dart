import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_user_challenge.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetUserChallenge usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetUserChallenge(mockRepository);
  });

  group('GetUserChallenge Test', () {
    group('execute', () {
      test(
          'should get user question answer list when execute function is called',
          () async {
        // arrange
        when(mockRepository.getUserChallenge(1))
            .thenAnswer((_) async => Right(testUserChallenge));
        // act
        final result = await usecase.execute(1);
        // assert
        expect(result, Right(testUserChallenge));
      });
    });
  });
}
