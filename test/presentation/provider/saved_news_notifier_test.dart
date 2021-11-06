import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_saved_feeds.dart';
import 'package:laporhoax/presentation/provider/saved_news_notifier.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:laporhoax/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'saved_news_notifier_test.mocks.dart';

@GenerateMocks([
  GetSavedFeeds,
])
void main() {
  late SavedNewsNotifier provider;
  late MockGetSavedFeeds mockGetSavedFeeds;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetSavedFeeds = MockGetSavedFeeds();
    provider = SavedNewsNotifier(
      getSavedFeeds: mockGetSavedFeeds,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change feeds data when data is gotten successfully', () async {
    // arrange
    when(mockGetSavedFeeds.execute())
        .thenAnswer((_) async => Right([testFeed]));
    // act
    await provider.fetchSavedFeeds();
    // assert
    expect(provider.feedListState, RequestState.Loaded);
    expect(provider.saveListFeeds, [testFeed]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetSavedFeeds.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchSavedFeeds();
    // assert
    expect(provider.feedListState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
