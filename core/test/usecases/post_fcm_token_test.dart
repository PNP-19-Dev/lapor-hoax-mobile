import 'package:core/domain/usecases/post_fcm_token.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late PostFCMToken usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = PostFCMToken(mockRepository);
  });

  final tUser = 1;
  final tToken = 'newPass';

  group('PostFCMToken Test', () {
    group('execute', () {
      test("should get 'success' callback when execute function is called",
          () async {
        // arrange
        when(mockRepository.postFCMToken(tUser, tToken))
            .thenAnswer((_) async => Right('success'));
        // act
        final result = await usecase.execute(tUser, tToken);
        // assert
        expect(result, Right('success'));
      });
    });
  });
}
