import 'package:core/domain/usecases/get_session_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late GetSessionStatus usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetSessionStatus(mockRepository);
  });

  test('should get session status from repository', () async {
    // arrange
    when(mockRepository.isSessionActivated()).thenAnswer((_) async => true);
    // act
    final result = await usecase.execute();
    // assert
    expect(result, true);
  });
}
