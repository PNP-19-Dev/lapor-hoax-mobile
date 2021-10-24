import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/domain/usecases/get_feed_detail.dart';
import 'package:laporhoax/domain/usecases/get_feed_save_status.dart';
import 'package:laporhoax/domain/usecases/remove_feed.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';
import 'package:laporhoax/presentation/provider/news_detail_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
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

  final tId = 1;

  void _arrangeUsecase() {
    when(mockGetFeedDetail.execute(tId))
        .thenAnswer((_) async => Right(testFeed));
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
      expect(provider.feedState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change feed when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchFeedDetail(tId);
      // assert
      expect(provider.feedState, RequestState.Loaded);
      expect(provider.feed, testFeed);
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
      when(mockSaveFeed.execute(testFeed))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetFeedSaveStatus.execute(testFeed.id))
          .thenAnswer((_) async => true);
      // act
      await provider.storeFeed(testFeed);
      // assert
      verify(mockSaveFeed.execute(testFeed));
    });

    test('should execute remove feed when function is called', () async {
      // arrange
      when(mockRemoveFeed.execute(testFeed))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetFeedSaveStatus.execute(testFeed.id))
          .thenAnswer((_) async => false);
      // act
      await provider.deleteFeed(testFeed);
      // assert
      verify(mockRemoveFeed.execute(testFeed));
    });

    test('should update feedlist message success', () async {
      // arrange
      when(mockSaveFeed.execute(testFeed))
          .thenAnswer((_) async => Right('Berita Telah Disimpan'));
      when(mockGetFeedSaveStatus.execute(testFeed.id))
          .thenAnswer((_) async => true);
      // act
      await provider.storeFeed(testFeed);
      // assert
      verify(mockGetFeedSaveStatus.execute(testFeed.id));
      expect(provider.isAddedtoSavedFeed, true);
      expect(provider.saveMessage, 'Berita Telah Disimpan');
      expect(listenerCallCount, 1);
    });

    test('should update feedlist message failed', () async {
      // arrange
      when(mockSaveFeed.execute(testFeed))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetFeedSaveStatus.execute(testFeed.id))
          .thenAnswer((_) async => false);
      // act
      await provider.storeFeed(testFeed);
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
      expect(provider.feedState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
