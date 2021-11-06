import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late PostRegister usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = PostRegister(mockRepository);
  });

  group('PostRegister Test', () {
    group('execute', () {
      test("should get user's callback when execute function is called",
          () async {
        // arrange
        when(mockRepository.postRegister(testRegister))
            .thenAnswer((_) async => Right(testRegisterData));
        // act
        final result = await usecase.execute(testRegister);
        // assert
        expect(result, Right(testRegisterData));
      });
    });
  });
}
