import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_feed_save_status.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';
import 'package:laporhoax/domain/usecases/get_saved_feeds.dart';
import 'package:laporhoax/domain/usecases/remove_feed.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';
import 'package:laporhoax/presentation/provider/feed_notifier.dart';
import 'package:mockito/annotations.dart';

import 'feed_notifier.mocks.dart';

@GenerateMocks([
  GetFeeds,
  SaveFeed,
  RemoveFeed,
  GetFeedSaveStatus,
  GetSavedFeeds,
])
void main() {
  late FeedNotifier provider;
  late MockGetFeeds mockGetFeeds;
  late MockSaveFeed mockSaveFeed;
  late MockRemoveFeed mockRemoveFeed;
  late MockGetFeedSaveStatus mockGetFeedSaveStatus;
  late MockGetSavedFeeds mockGetSavedFeeds;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetFeeds = MockGetFeeds();
    mockSaveFeed = MockSaveFeed();
    mockRemoveFeed = MockRemoveFeed();
    mockGetFeedSaveStatus = MockGetFeedSaveStatus();
    mockGetSavedFeeds = MockGetSavedFeeds();
    provider = FeedNotifier(
      getFeeds: mockGetFeeds,
      saveFeed: mockSaveFeed,
      removeFeed: mockRemoveFeed,
      getFeedSaveStatus: mockGetFeedSaveStatus,
      getSavedFeeds: mockGetSavedFeeds,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });
}
