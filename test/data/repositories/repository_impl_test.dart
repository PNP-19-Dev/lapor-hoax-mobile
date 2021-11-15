/*
 * Created by andii on 15/11/21 12.51
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 15/11/21 12.12
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/data/models/question_model.dart';
import 'package:laporhoax/data/models/report_model.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/user_model.dart';
import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/data/repositories/repository_impl.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/utils/exception.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:laporhoax/utils/network_exceptions.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tEmail = 'email';
  final tToken = 'token';
  final tId = 1;
  final tOldPass = 'oldPass';
  final tNewPass = 'newPass';
  final tUsername = 'username';

  group('Delete Report', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.deleteReport(tToken, tId))
          .thenAnswer((_) async => 'success');
      // act
      final result = await repository.deleteReport(tToken, tId);
      // assert
      verify(mockRemoteDataSource.deleteReport(tToken, tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultMessage = result.getOrElse(() => 'success');
      expect(resultMessage, 'success');
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.deleteReport(tToken, tId))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.deleteReport(tToken, tId);
      // assert
      verify(mockRemoteDataSource.deleteReport(tToken, tId));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Get Categories', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getCategory())
          .thenAnswer((realInvocation) async => []);
      // act
      await repository.getCategories();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });

      test('should return data when the call to remote data is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getCategory())
            .thenAnswer((_) async => [testCategoryModel]);
        // act
        final result = await repository.getCategories();
        // assert
        verify(mockRemoteDataSource.getCategory());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testCategory]);
      });

      test(
          'should cache data locally when the call to remote data is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getCategory())
            .thenAnswer((_) async => [testCategoryModel]);
        // act
        await repository.getCategories();
        // assert
        verify(mockRemoteDataSource.getCategory());
        verify(mockLocalDataSource.cacheCategory([testCategoryTable]));
      });

      test('should return server failure', () async {
        // arrange
        when(mockRemoteDataSource.getCategory())
            .thenThrow(NetworkExceptions.defaultError(''));
        // act
        final result = await repository.getCategories();
        // assert
        verify(mockRemoteDataSource.getCategory());
        expect(
            result,
            equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
                NetworkExceptions.defaultError(''))))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedCategory())
            .thenAnswer((_) async => [testCategoryTable]);
        // act
        final result = await repository.getCategories();
        // assert
        verify(mockLocalDataSource.getCachedCategory());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testCategory]);
      });

      test('should return failure when device cache is unavailable', () async {
        // arrange
        when(mockLocalDataSource.getCachedCategory())
            .thenThrow(CacheException("Can't get the data :("));
        // act
        final result = await repository.getCategories();
        // assert
        verify(mockLocalDataSource.getCachedCategory());
        expect(result, equals(Left(CacheFailure("Can't get the data :("))));
      });
    });
  });

  group('Get Feed Detail', () {
    test(
        'should return Feed data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getFeedDetail(tId))
          .thenAnswer((_) async => testFeedModel);
      // act
      final result = await repository.getFeedDetail(tId);
      // assert
      verify(mockRemoteDataSource.getFeedDetail(tId));
      expect(result, equals(Right(testFeed)));
    });
    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getFeedDetail(tId))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.getFeedDetail(tId);
      // assert
      verify(mockRemoteDataSource.getFeedDetail(tId));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Get Feed Save Status', () {
    test('should return save status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getFeedById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToSavedFeed(tId);
      // assert
      expect(result, false);
    });
  });

  group('Get Feeds', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getFeeds())
          .thenAnswer((_) async => [testFeedModel]);
      // act
      final result = await repository.getFeeds();
      // assert
      verify(mockRemoteDataSource.getFeeds());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultMessage = result.getOrElse(() => []);
      expect(resultMessage, testFeedList);
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getFeeds())
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.getFeeds();
      // assert
      verify(mockRemoteDataSource.getFeeds());
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Get Password Reset', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPasswordReset(tEmail))
          .thenAnswer((_) async => 'Success');
      // act
      final result = await repository.getPasswordReset(tEmail);
      // assert
      verify(mockRemoteDataSource.getPasswordReset(tEmail));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultMessage = result.getOrElse(() => 'Failure');
      expect(resultMessage, 'Success');
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPasswordReset(tEmail))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.getPasswordReset(tEmail);
      // assert
      verify(mockRemoteDataSource.getPasswordReset(tEmail));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Get Questions', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getCategory())
          .thenAnswer((realInvocation) async => []);
      // act
      await repository.getCategories();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        final tQuestionResponse = QuestionModel(id: 1, question: 'question');
        // arrange
        when(mockRemoteDataSource.getQuestions())
            .thenAnswer((_) async => [tQuestionResponse]);
        // act
        final result = await repository.getQuestions();
        // assert
        verify(mockRemoteDataSource.getQuestions());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultMessage = result.getOrElse(() => []);
        expect(resultMessage, [testQuestion]);
      });
      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getQuestions())
            .thenThrow(NetworkExceptions.defaultError(''));
        // act
        final result = await repository.getQuestions();
        // assert
        verify(mockRemoteDataSource.getQuestions());
        expect(
            result,
            equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
                NetworkExceptions.defaultError(''))))));
      });

      test(
          'should cache data locally when the call to remote data is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getQuestions())
            .thenAnswer((realInvocation) async => [testQuestionModel]);
        // act
        await repository.getQuestions();
        // assert
        verify(mockRemoteDataSource.getQuestions());
        verify(mockLocalDataSource.cacheQuestions([testQuestionTable]));
      });

      test('should return server failure', () async {});
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedQuestion())
            .thenAnswer((_) async => [testQuestionTable]);
        // act
        final result = await repository.getQuestions();
        // assert
        verify(mockLocalDataSource.getCachedQuestion());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testQuestion]);
      });

      test('should return failure when device cache is unavailable', () async {
        // arrange
        when(mockLocalDataSource.getCachedQuestion())
            .thenThrow(CacheException("Can't get the data :("));
        // act
        final result = await repository.getQuestions();
        // assert
        verify(mockLocalDataSource.getCachedQuestion());
        expect(result, equals(Left(CacheFailure("Can't get the data :("))));
      });
    });
  });

  group('Get Reports', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      final tReportResponse = ReportModel(
        id: 59,
        url: "www.aslihoax.com",
        img:
            "https://django-lapor-hoax.s3.amazonaws.com/reports/Capture.PNG?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=6eGLu1R0U3qsyUf5sb%2B2up%2B9DzU%3D&Expires=1634827154",
        category: "Isu SARA",
        status: "Selesai",
        isAnonym: false,
        dateReported: "2021-10-13T03:33:41.647173+07:00",
        description: "Menyebarkan berita hoax",
        prosesDate: "2021-10-15T03:52:34.695336+07:00",
        verdict: "Diterima",
        verdictDesc: "respon",
        verdictDate: "2021-10-15T04:01:28.042973+07:00",
        user: 1,
        verdictJudge: 1,
      );
      // arrange
      when(mockRemoteDataSource.getReport(tToken, tId))
          .thenAnswer((_) async => [tReportResponse]);
      // act
      final result = await repository.getReports(tToken, tId);
      // assert
      verify(mockRemoteDataSource.getReport(tToken, tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultMessage = result.getOrElse(() => []);
      expect(resultMessage, testReportList);
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getReport(tToken, tId))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.getReports(tToken, tId);
      // assert
      verify(mockRemoteDataSource.getReport(tToken, tId));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Get Saved Feeds', () {
    final tFeed = Feed(
      id: 1,
      title: "title",
      content: null,
      thumbnail: "thumbnail",
      date: "date",
      view: null,
      author: null,
    );
    test('should return list of Feeds', () async {
      // arrange
      when(mockLocalDataSource.getFeeds())
          .thenAnswer((_) async => [testFeedTable]);
      // act
      final result = await repository.getSavedFeeds();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [tFeed]);
    });
  });

  group('Get Session Data', () {
    test('should return session status', () async {
      final sessionData = SessionData(
        token: "token",
        userid: 1,
        expiry: "expiry",
        email: "email",
        username: "username",
      );
      // arrange
      when(mockLocalDataSource.getSession())
          .thenAnswer((_) async => sessionData);
      // act
      final result = await repository.getSessionData();
      // assert
      verify(mockLocalDataSource.getSession());
      expect(result, Right(sessionData));
    });

    test('should error when result is null', () async {
      // arrange
      when(mockLocalDataSource.getSession()).thenAnswer((_) async => null);
      // act
      final result = await repository.getSessionData();
      // assert
      expect(result, Left(CustomException('No Data')));
    });
  });

  group('Get Session Status', () {
    test('should return true whether data is found', () async {
      // arrange
      when(mockLocalDataSource.isLoggedIn()).thenAnswer((_) async => true);
      // act
      final result = await repository.isSessionActivated();
      // assert
      expect(result, true);
    });
  });

  group('Get User', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      final tUserModel = UserModel(id: 1, username: "username", email: "email");
      // arrange
      when(mockRemoteDataSource.getUser(tEmail))
          .thenAnswer((_) async => tUserModel);
      // act
      final result = await repository.getUser(tEmail);
      // assert
      verify(mockRemoteDataSource.getUser(tEmail));
      expect(result, equals(Right(testUser)));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getUser(tEmail))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.getUser(tEmail);
      // assert
      verify(mockRemoteDataSource..getUser(tEmail));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Get User Challenge', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      final tUserQuestionModel = UserQuestionModel(
        user: "user",
        quest1: 1,
        quest2: 2,
        quest3: 3,
        ans1: "ans1",
        ans2: "ans2",
        ans3: "ans3",
      );
      // arrange
      when(mockRemoteDataSource.getUserQuestions(tId))
          .thenAnswer((_) async => tUserQuestionModel);
      // act
      final result = await repository.getUserChallenge(tId);
      // assert
      verify(mockRemoteDataSource.getUserQuestions(tId));
      expect(result, equals(Right(testUserChallenge)));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getUserQuestions(tId))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.getUserChallenge(tId);
      // assert
      verify(mockRemoteDataSource.getUserQuestions(tId));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Post Change Password', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.putPassword(tOldPass, tNewPass, tToken))
          .thenAnswer((_) async => 'Success');
      // act
      final result = await repository.putPassword(tOldPass, tNewPass, tToken);
      // assert
      verify(mockRemoteDataSource.putPassword(tOldPass, tNewPass, tToken));
      expect(result, equals(Right('Success')));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.putPassword(tOldPass, tNewPass, tToken))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.putPassword(tOldPass, tNewPass, tToken);
      // assert
      verify(mockRemoteDataSource.putPassword(tOldPass, tNewPass, tToken));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Post FCM Token', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.postFcmToken(tId.toString(), tToken))
          .thenAnswer((_) async => 'Success');
      // act
      final result = await repository.postFCMToken(tId, tToken);
      // assert
      verify(mockRemoteDataSource.postFcmToken(tId.toString(), tToken));
      expect(result, equals(Right('Success')));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.postFcmToken(tId.toString(), tToken))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.postFCMToken(tId, tToken);
      // assert
      verify(mockRemoteDataSource.postFcmToken(tId.toString(), tToken));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Put FCM Token', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.putFcmToken(tId.toString(), tToken))
          .thenAnswer((_) async => 'Success');
      // act
      final result = await repository.putFCMToken(tId, tToken);
      // assert
      verify(mockRemoteDataSource.putFcmToken(tId.toString(), tToken));
      expect(result, equals(Right('Success')));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.putFcmToken(tId.toString(), tToken))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.putFCMToken(tId, tToken);
      // assert
      verify(mockRemoteDataSource.putFcmToken(tId.toString(), tToken));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Post Login', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.postLogin(tUsername, tOldPass))
          .thenAnswer((_) async => testLoginModel);
      // act
      final result = await repository.postLogin(tUsername, tOldPass);
      // assert
      verify(mockRemoteDataSource.postLogin(tUsername, tOldPass));
      expect(result, equals(Right(testLogin)));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.postLogin(tUsername, tOldPass))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.postLogin(tUsername, tOldPass);
      // assert
      verify(mockRemoteDataSource.postLogin(tUsername, tOldPass));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Post Register', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.postRegister(testRegisterModel))
          .thenAnswer((_) async => testRegisterCallback);
      // act
      final result = await repository.postRegister(testRegister);
      // assert
      verify(mockRemoteDataSource.postRegister(testRegisterModel));
      expect(result, equals(Right(testRegisterCallback.toEntity())));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.postRegister(testRegisterModel))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.postRegister(testRegister);
      // assert
      verify(mockRemoteDataSource.postRegister(testRegisterModel));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Post Report', () {
    final tReportCompose = ReportRequest(
      user: 1,
      url: "url",
      category: "category",
      isAnonym: false,
      description: "description",
      img: XFile('null'),
    );
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.postReport(tToken, tReportCompose))
          .thenAnswer((_) async => testReportModel);
      // act
      final result = await repository.postReport(tToken, tReportCompose);
      // assert
      verify(mockRemoteDataSource.postReport(tToken, tReportCompose));
      expect(result, equals(Right(testReport)));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.postReport(tToken, tReportCompose))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.postReport(tToken, tReportCompose);
      // assert
      verify(mockRemoteDataSource.postReport(tToken, tReportCompose));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Post User Challenge', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.postChallenge(testUserChallengeModel))
          .thenAnswer((_) async => 'Success');
      // act
      final result = await repository.postUserChallenge(testUserChallenge);
      // assert
      verify(mockRemoteDataSource.postChallenge(testUserChallengeModel));
      expect(result, equals(Right('Success')));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.postChallenge(testUserChallengeModel))
          .thenThrow(NetworkExceptions.defaultError(''));
      // act
      final result = await repository.postUserChallenge(testUserChallenge);
      // assert
      verify(mockRemoteDataSource.postChallenge(testUserChallengeModel));
      expect(
          result,
          equals(Left(ServerFailure(NetworkExceptions.getErrorMessage(
              NetworkExceptions.defaultError(''))))));
    });
  });

  group('Remove Feed', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeFeed(FeedTable.fromEntity(testFeed)))
          .thenAnswer((_) async => 'Removed from Feed');
      // act
      final result = await repository.removeFeed(testFeed);
      // assert
      expect(result, Right('Removed from Feed'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeFeed(FeedTable.fromEntity(testFeed)))
          .thenThrow(DatabaseException('Failed to remove Feed'));
      // act
      final result = await repository.removeFeed(testFeed);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove Feed')));
    });
  });

  group('Remove Session Data', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeSession(testSessionData))
          .thenAnswer((_) async => 'Session Removed');
      // act
      final result = await repository.removeSessionData(testSessionData);
      // assert
      expect(result, 'Session Removed');
    });
  });

  group('Save Feed', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertFeed(FeedTable.fromEntity(testFeed)))
          .thenAnswer((_) async => 'Feed Saved');
      // act
      final result = await repository.saveFeed(testFeed);
      // assert
      expect(result, Right('Feed Saved'));
    });
    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertFeed(FeedTable.fromEntity(testFeed)))
          .thenThrow(DatabaseException('Failed to save Feed'));
      // act
      final result = await repository.saveFeed(testFeed);
      // assert
      expect(result, Left(DatabaseFailure('Failed to save Feed')));
    });
  });

  group('Save Session Data', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertSession(
        email: testSessionData.email,
        expiry: testSessionData.expiry,
        token: testSessionData.expiry,
        username: testSessionData.username,
        id: testSessionData.userid,
      )).thenAnswer((_) async => 'Session Saved');
      // act
      final result = await repository.saveSessionData(
        email: testSessionData.email,
        expiry: testSessionData.expiry,
        token: testSessionData.expiry,
        username: testSessionData.username,
        id: testSessionData.userid,
      );
      // assert
      expect(result, 'Session Saved');
    });
  });
}
