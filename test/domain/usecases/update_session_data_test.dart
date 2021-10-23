import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/update_session_data.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late UpdateSessionData usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = UpdateSessionData(mockRepository);
  });

  test('should remove feed from saved feed in repository', () async {
    // arrange
    when(mockRepository.updateSessionData(testSessionData))
        .thenAnswer((_) async => Right('Anda Login'));
    // act
    final result = await usecase.execute(testSessionData);
    // assert
    verify(mockRepository.updateSessionData(testSessionData));
    expect(result, Right('Anda Login'));
  });
}
