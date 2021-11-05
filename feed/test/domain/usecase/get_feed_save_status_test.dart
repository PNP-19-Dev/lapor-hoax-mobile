import 'package:feed/domain/usecases/get_feed_save_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/feed_test_helpers.mocks.dart';

void main() {
  late GetFeedSaveStatus usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetFeedSaveStatus(mockRepository);
  });

  test('should get feed saving status from repository', () async {
    // arrange
    when(mockRepository.isAddedToSavedFeed(1)).thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
