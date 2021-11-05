import 'package:core/domain/entities/feed.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:feed/domain/usecases/get_saved_feeds.dart';
import 'package:feed/presentation/provider/saved_news_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/saved_news_notifier_test.mocks.dart';

@GenerateMocks([GetSavedFeeds])
void main() {
  late SavedNewsNotifier provider;
  late MockGetSavedFeeds mockGetSavedFeeds;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetSavedFeeds = MockGetSavedFeeds();
    provider = SavedNewsNotifier(getSavedFeeds: mockGetSavedFeeds)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tFeed = Feed(
    id: 26,
    title: "Libur Maulid Nabi 2021 Digeser: Tanggal dan Alasannya",
    content: "content",
    thumbnail:
        "https://django-lapor-hoax.s3.amazonaws.com/feeds/1.jpeg?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=yXthBiGVfwxxC%2Flai%2FvL0PZAMz4%3D&Expires=1634826461",
    date: "2021-10-13T01:34:58.831621+07:00",
    view: 0,
    author: 1,
  );

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetSavedFeeds.execute()).thenAnswer((_) async => Right([tFeed]));
    // act
    await provider.fetchSavedFeeds();
    // assert
    expect(provider.feedListState, RequestState.loaded);
    expect(provider.saveListFeeds, [tFeed]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetSavedFeeds.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchSavedFeeds();
    // assert
    expect(provider.feedListState, RequestState.error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
