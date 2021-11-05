import 'package:core/domain/usecases/post_login.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../dummy_data/dummy_objects.dart';
import '../helpers/test_helper.mocks.dart';

void main() {
  late PostLogin usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = PostLogin(mockRepository);
  });

  final tUsername = 'username';
  final tPassword = 'password';

  group('PostLogin Test', () {
    group('execute', () {
      test("should get token callback when execute function is called",
          () async {
        // arrange
        when(mockRepository.postLogin(tUsername, tPassword))
            .thenAnswer((_) async => Right(testLogin));
        // act
        final result = await usecase.execute(tUsername, tPassword);
        // assert
        expect(result, Right(testLogin));
      });
    });
  });
}
