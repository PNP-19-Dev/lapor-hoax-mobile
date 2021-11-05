import 'package:core/domain/entities/feed.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:feed/domain/usecases/get_feed_detail.dart';
import 'package:feed/domain/usecases/get_feed_save_status.dart';
import 'package:feed/domain/usecases/remove_feed.dart';
import 'package:feed/domain/usecases/save_feed.dart';
import 'package:feed/presentation/provider/news_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'news_web_view_test.mocks.dart';

@GenerateMocks([
  GetFeedDetail,
  SaveFeed,
  RemoveFeed,
  GetFeedSaveStatus,
])
void main() {
  late NewsDetailNotifier provider;
  late MockGetFeedDetail mockGetFeedDetail;
  late MockSaveFeed mockSaveFeed;
  late MockRemoveFeed mockRemoveFeed;
  late MockGetFeedSaveStatus mockGetFeedSaveStatus;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetFeedDetail = MockGetFeedDetail();
    mockSaveFeed = MockSaveFeed();
    mockRemoveFeed = MockRemoveFeed();
    mockGetFeedSaveStatus = MockGetFeedSaveStatus();
    provider = NewsDetailNotifier(
      getFeedDetail: mockGetFeedDetail,
      saveFeed: mockSaveFeed,
      removeFeed: mockRemoveFeed,
      getFeedSaveStatus: mockGetFeedSaveStatus,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tId = 1;
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

  void _arrangeUsecase() {
    when(mockGetFeedDetail.execute(tId)).thenAnswer((_) async => Right(tFeed));
  }

  group('Get Feed Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchFeedDetail(tId);
      // assert
      verify(mockGetFeedDetail.execute(tId));
    });

    test('should change state to loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchFeedDetail(tId);
      // assert
      expect(provider.feedState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change feed when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchFeedDetail(tId);
      // assert
      expect(provider.feedState, RequestState.loaded);
      expect(provider.feed, tFeed);
      expect(listenerCallCount, 2);
    });
  });

  group('Saved List', () {
    test('should get the save status', () async {
      // arrange
      when(mockGetFeedSaveStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadFeedStatus(1);
      // assert
      expect(provider.isAddedtoSavedFeed, true);
    });

    test('should execute save feed when function is called', () async {
      // arrange
      when(mockSaveFeed.execute(tFeed))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetFeedSaveStatus.execute(tFeed.id))
          .thenAnswer((_) async => true);
      // act
      await provider.storeFeed(tFeed);
      // assert
      verify(mockSaveFeed.execute(tFeed));
    });

    test('should execute remove feed when function is called', () async {
      // arrange
      when(mockRemoveFeed.execute(tFeed))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetFeedSaveStatus.execute(tFeed.id))
          .thenAnswer((_) async => false);
      // act
      await provider.deleteFeed(tFeed);
      // assert
      verify(mockRemoveFeed.execute(tFeed));
    });

    test('should update feedlist message success', () async {
      // arrange
      when(mockSaveFeed.execute(tFeed))
          .thenAnswer((_) async => const Right('Berita Telah Disimpan'));
      when(mockGetFeedSaveStatus.execute(tFeed.id))
          .thenAnswer((_) async => true);
      // act
      await provider.storeFeed(tFeed);
      // assert
      verify(mockGetFeedSaveStatus.execute(tFeed.id));
      expect(provider.isAddedtoSavedFeed, true);
      expect(provider.saveMessage, 'Berita Telah Disimpan');
      expect(listenerCallCount, 1);
    });

    test('should update feedlist message failed', () async {
      // arrange
      when(mockSaveFeed.execute(tFeed))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetFeedSaveStatus.execute(tFeed.id))
          .thenAnswer((_) async => false);
      // act
      await provider.storeFeed(tFeed);
      // assert
      expect(provider.saveMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetFeedDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchFeedDetail(tId);
      // assert
      expect(provider.feedState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
