import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';
import 'package:laporhoax/presentation/provider/feed_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'feed_notifier_test.mocks.dart';

@GenerateMocks([
  GetFeeds,
])
void main() {
  late FeedNotifier provider;
  late MockGetFeeds mockGetFeeds;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetFeeds = MockGetFeeds();
    provider = FeedNotifier(
      getFeeds: mockGetFeeds,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change feeds data when data is gotten successfully', () async {
    // arrange
    when(mockGetFeeds.execute()).thenAnswer((_) async => Right([testFeed]));
    // act
    await provider.fetchFeeds();
    // assert
    expect(provider.feedState, RequestState.Loaded);
    expect(provider.feeds, [testFeed]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetFeeds.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchFeeds();
    // assert
    expect(provider.feedState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 1);
  });
}
