import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_saved_feeds.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetSavedFeeds usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetSavedFeeds(mockRepository);
  });

  group('GetSavedFeeds Test', () {
    group('execute', () {
      test('should get list of savedFeed when execute function is called',
          () async {
        // arrange
        when(mockRepository.getSavedFeeds())
            .thenAnswer((_) async => Right(testFeedList));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(testFeedList));
      });
    });
  });
}
