import 'package:core/data/datasources/local_data_source.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late LocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockPreferencesHelper mockPreferencesHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockPreferencesHelper = MockPreferencesHelper();
    dataSource = LocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
      preferencesHelper: mockPreferencesHelper,
    );
  });

  group('Save Feed', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertNews(testFeedTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertFeed(testFeedTable);
      // assert
      expect(result, 'Feed Saved');
    });

    test('should throw DatabaseException when insert to database is failed',
        () {
      // arrange
      when(mockDatabaseHelper.insertNews(testFeedTable)).thenThrow(Exception());
      // act
      final call = dataSource.insertFeed(testFeedTable);
      // assert
      expect(call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Remove Feed', () {
    test('should return success message when remove to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeFeed(testFeedTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeFeed(testFeedTable);
      // assert
      expect(result, 'Feed Removed');
    });

    test('should throw DatabaseException when insert to database is failed',
        () {
      // arrange
      when(mockDatabaseHelper.removeFeed(testFeedTable)).thenThrow(Exception());
      // act
      final call = dataSource.removeFeed(testFeedTable);
      // assert
      expect(call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Feed Detail By Id', () {
    final tId = 1;

    test('should return Feed Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getFeedById(tId))
          .thenAnswer((_) async => testFeedMap);
      // act
      final result = await dataSource.getFeedById(tId);
      // assert
      expect(result, testFeedTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getFeedById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getFeedById(tId);
      // assert
      expect(result, null);
    });
  });

  group('Get Feed Lists', () {
    test('should return list of MovieTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getFeeds())
          .thenAnswer((_) async => [testFeedMap]);
      // act
      final result = await dataSource.getFeeds();
      // assert
      expect(result, [testFeedTable]);
    });
  });

  group('Is Log in', () {
    test('should return login status', () async {
      // arrange
      when(mockPreferencesHelper.isLogin).thenAnswer((_) async => true);
      // act
      final result = await dataSource.isLoggedIn();
      // assert
      expect(result, true);
    });
  });

  group('cache categories', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearCategoryCache()).thenAnswer((_) async => 1);
      // act
      await dataSource.cacheCategory([testCategory]);
      // assert
      verify(mockDatabaseHelper.clearCategoryCache());
      verify(mockDatabaseHelper.insertCategoryTransaction([testCategory]));
    });

    test('should return list of categories when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCategoryCache())
          .thenAnswer((_) async => [testCategoryMap]);
      // act
      final result = await dataSource.getCachedCategory();
      // assert
      expect(result, [testCategory]);
    });

    test('should throw CacheException when data is not exist', () async {
      // arrange
      when(mockDatabaseHelper.getCategoryCache()).thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedCategory();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });

  group('cache questions', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearQuestionCache()).thenAnswer((_) async => 1);
      // act
      await dataSource.cacheQuestions([testQuestion]);
      // assert
      verify(mockDatabaseHelper.clearQuestionCache());
      verify(mockDatabaseHelper.insertQuestionTransaction([testQuestion]));
    });

    test('should return list of categories when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getQuestionCache())
          .thenAnswer((_) async => [testQuestionMap]);
      // act
      final result = await dataSource.getCachedQuestion();
      // assert
      expect(result, [testQuestion]);
    });

    test('should throw CacheException when data is not exist', () async {
      // arrange
      when(mockDatabaseHelper.getQuestionCache()).thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedQuestion();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });
}
