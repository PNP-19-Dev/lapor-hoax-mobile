import 'package:core/domain/usecases/remove_session_data.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../dummy_data/dummy_objects.dart';
import '../helpers/test_helper.mocks.dart';

void main() {
  late RemoveSessionData usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = RemoveSessionData(mockRepository);
  });

  test("should remove user's session in repository", () async {
    // arrange
    when(mockRepository.removeSessionData(testSessionData))
        .thenAnswer((_) async => const Right('Anda Logout'));
    // act
    final result = await usecase.execute(testSessionData);
    // assert
    verify(mockRepository.removeSessionData(testSessionData));
    expect(result, const Right('Anda Logout'));
  });
}
