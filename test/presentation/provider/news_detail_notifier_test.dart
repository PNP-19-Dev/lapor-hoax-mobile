import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_feed_detail.dart';
import 'package:laporhoax/domain/usecases/get_feed_save_status.dart';
import 'package:laporhoax/domain/usecases/remove_feed.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';
import 'package:laporhoax/presentation/provider/news_detail_notifier.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:laporhoax/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'news_detail_notifier_test.mocks.dart';

@GenerateMocks([
  SaveFeed,
  RemoveFeed,
  GetFeedSaveStatus,
  GetFeedDetail,
])
void main() {
  late NewsDetailNotifier provider;
  late MockSaveFeed mockSaveFeed;
  late MockRemoveFeed mockRemoveFeed;
  late MockGetFeedSaveStatus mockGetFeedSaveStatus;
  late MockGetFeedDetail mockGetFeedDetail;
  late int listenerCallCount;

  final tId = 1;

  setUp(() {
    listenerCallCount = 0;
    mockSaveFeed = MockSaveFeed();
    mockRemoveFeed = MockRemoveFeed();
    mockGetFeedSaveStatus = MockGetFeedSaveStatus();
    mockGetFeedDetail = MockGetFeedDetail();
    provider = NewsDetailNotifier(
      getFeedDetail: mockGetFeedDetail,
      saveFeed: mockSaveFeed,
      removeFeed: mockRemoveFeed,
      getFeedSaveStatus: mockGetFeedSaveStatus,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  void _arrangeUseCase() {
    when(mockGetFeedDetail.execute(tId))
        .thenAnswer((_) async => Right(testFeed));
  }

  group('Get Feed Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUseCase();
      // act
      await provider.fetchFeedDetail(tId);
      // assert
      verify(mockGetFeedDetail.execute(tId));
    });

    test('should change state to Loading when usecase is called', () async {
      // arrange
      _arrangeUseCase();
      // act
      provider.fetchFeedDetail(tId);
      // assert
      expect(provider.feedState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change feed when data is gotten successfully', () async {
      // arrange
      _arrangeUseCase();
      // act
      await provider.fetchFeedDetail(tId);
      // assert
      expect(provider.feedState, RequestState.Loaded);
      expect(provider.feed, testFeed);
      expect(listenerCallCount, 2);
    });
  });

  group('Bookmark', () {
    test('should get the mark status', () async {
      // arrange
      when(mockGetFeedSaveStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadFeedStatus(1);
      // assert
      expect(provider.isAddedtoSavedFeed, true);
    });

    test('should execute save bookmark when function called', () async {
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

    test('should execute remove bookmark when function called', () async {
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

    test('should give error callback when function error', () async {
      // arrange
      when(mockRemoveFeed.execute(testFeed))
          .thenAnswer((_) async => Left(DatabaseFailure('Error')));
      when(mockGetFeedSaveStatus.execute(testFeed.id))
          .thenAnswer((_) async => true);
      // act
      await provider.deleteFeed(testFeed);
      // assert
      verify(mockRemoveFeed.execute(testFeed));
      expect(provider.saveMessage, 'Error');
    });


    test('should update feed bookmark list when function called', () async {
      // arrange
      when(mockSaveFeed.execute(testFeed))
          .thenAnswer((_) async => Right('Berita Telah Disimpan'));
      when(mockGetFeedSaveStatus.execute(testFeed.id))
          .thenAnswer((_) async => true);
      // act
      await provider.storeFeed(testFeed);
      // assert
      verify(mockSaveFeed.execute(testFeed));
      expect(provider.isAddedtoSavedFeed, true);
      expect(provider.saveMessage, 'Berita Telah Disimpan');
      expect(listenerCallCount, 1);
    });

    test('should update feed bookmark message when add bookmark failed',
        () async {
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
