import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/common/exception.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/models/category_model.dart';
import 'package:laporhoax/data/models/question_model.dart';
import 'package:laporhoax/data/models/report_model.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/user_model.dart';
import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/data/repositories/repository_impl.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
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
          .thenThrow(ServerException());
      // act
      final result = await repository.deleteReport(tToken, tId);
      // assert
      verify(mockRemoteDataSource.deleteReport(tToken, tId));
      expect(result, equals(Left(ServerFailure('Cant Delete Report'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.deleteReport(tToken, tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.deleteReport(tToken, tId);
      // assert
      verify(mockRemoteDataSource.deleteReport(tToken, tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
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

      test('should reutrn data when the call to remote data is successful',
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
        verify(mockLocalDataSource.cacheCategory([testCategory]));
      });

      test('should return server failure', () async {
        // arrange
        when(mockRemoteDataSource.getCategory()).thenThrow(ServerException());
        // act
        final result = await repository.getCategories();
        // assert
        verify(mockRemoteDataSource.getCategory());
        expect(result, equals(Left(ServerFailure('Cant Fetch Categories'))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return connection failure when the device is not connected',
          () async {});

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedCategory())
            .thenAnswer((_) async => [testCategory]);
        // act
        final result = await repository.getCategories();
        // assert
        verify(mockLocalDataSource.getCachedCategory());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testCategory]);
      });
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      final tCategoryResponse = CategoryModel(name: 'name', id: 1);
      // arrange
      when(mockRemoteDataSource.getCategory())
          .thenAnswer((_) async => [tCategoryResponse]);
      // act
      final result = await repository.getCategories();
      // assert
          verify(mockRemoteDataSource.getCategory());
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultMessage = result.getOrElse(() => []);
          expect(resultMessage, [testCategory]);
        });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getCategory()).thenThrow(ServerException());
      // act
      final result = await repository.getCategories();
      // assert
      verify(mockRemoteDataSource.getCategory());
      expect(result, equals(Left(ServerFailure('Cant Fetch Categories'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getCategory())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getCategories();
          // assert
          verify(mockRemoteDataSource.getCategory());
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
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
          .thenThrow(ServerException());
      // act
      final result = await repository.getFeedDetail(tId);
      // assert
      verify(mockRemoteDataSource.getFeedDetail(tId));
      expect(result, equals(Left(ServerFailure('Failed To Get Detail'))));
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
          when(mockRemoteDataSource.getFeeds()).thenThrow(ServerException());
      // act
      final result = await repository.getFeeds();
      // assert
      verify(mockRemoteDataSource.getFeeds());
      expect(result, equals(Left(ServerFailure('Cant Retrieve Feed Data'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getFeeds())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getFeeds();
      // assert
      verify(mockRemoteDataSource.getFeeds());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
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
          .thenThrow(ServerException());
      // act
      final result = await repository.getPasswordReset(tEmail);
      // assert
      verify(mockRemoteDataSource.getPasswordReset(tEmail));
      expect(result, equals(Left(ServerFailure('Cant Reset'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
          when(mockRemoteDataSource.getPasswordReset(tEmail))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPasswordReset(tEmail);
      // assert
      verify(mockRemoteDataSource.getPasswordReset(tEmail));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
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
        when(mockRemoteDataSource.getQuestions()).thenThrow(ServerException());
        // act
        final result = await repository.getQuestions();
        // assert
        verify(mockRemoteDataSource.getQuestions());
        expect(result, equals(Left(ServerFailure(''))));
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
        verify(mockLocalDataSource.cacheQuestions([testQuestion]));
      });

      test('should return server failure', () async {});
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return connection failure when the device is not connected to internet',
          () async {
        // arrange
        when(mockRemoteDataSource.getQuestions())
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getQuestions();
        // assert
        verify(mockRemoteDataSource.getQuestions());
        expect(
            result,
            equals(
                Left(ConnectionFailure('Failed to connect to the network'))));
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedQuestion())
            .thenAnswer((_) async => [testQuestion]);
        // act
        final result = await repository.getQuestions();
        // assert
        verify(mockLocalDataSource.getCachedQuestion());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testCategory]);
      });
    });
  });

  group('Get Reports', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      final tReportResponse = ReportModel(
        id: 1,
        url: "url",
        img: "img",
        category: "category",
        status: "status",
        isAnonym: false,
        dateReported: "dateReported",
        description: "description",
        prosesDate: "prosesDate",
        verdict: "verdict",
        verdictDesc: "verdictDesc",
        verdictDate: "verdictDate",
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
          .thenThrow(ServerException());
      // act
      final result = await repository.getReports(tToken, tId);
      // assert
      verify(mockRemoteDataSource.getReport(tToken, tId));
      expect(result, equals(Left(ServerFailure('Cant Fetch Reports'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getReport(tToken, tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getReports(tToken, tId);
      // assert
      verify(mockRemoteDataSource.getReport(tToken, tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
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
      expect(result, Right(sessionData));
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
          .thenAnswer((_) async => [tUserModel]);
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
          when(mockRemoteDataSource.getUser(tEmail)).thenThrow(ServerException());
      // act
      final result = await repository.getUser(tEmail);
      // assert
      verify(mockRemoteDataSource..getUser(tEmail));
      expect(result, equals(Left(ServerFailure('Not Found'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getUser(tEmail))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getUser(tEmail);
      // assert
      verify(mockRemoteDataSource.getUser(tEmail));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
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
          .thenThrow(ServerException());
      // act
      final result = await repository.getUserChallenge(tId);
      // assert
      verify(mockRemoteDataSource.getUserQuestions(tId));
      expect(result, equals(Left(ServerFailure('Failed to Get Data'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getUser(tEmail))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getUser(tEmail);
      // assert
      verify(mockRemoteDataSource.getUser(tEmail));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
  group('Post Change Password', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.postChangePassword(tOldPass, tNewPass, tToken))
          .thenAnswer((_) async => 'Success');
      // act
      final result =
          await repository.postChangePassword(tOldPass, tNewPass, tToken);
      // assert
      verify(
          mockRemoteDataSource.postChangePassword(tOldPass, tNewPass, tToken));
      expect(result, equals(Right('Success')));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
          when(mockRemoteDataSource.postChangePassword(tOldPass, tNewPass, tToken))
          .thenThrow(ServerException());
      // act
      final result =
          await repository.postChangePassword(tOldPass, tNewPass, tToken);
      // assert
      verify(
          mockRemoteDataSource.postChangePassword(tOldPass, tNewPass, tToken));
      expect(result, equals(Left(ServerFailure('Cant Change Password'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.postChangePassword(tOldPass, tNewPass, tToken))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result =
          await repository.postChangePassword(tOldPass, tNewPass, tToken);
      // assert
      verify(
          mockRemoteDataSource.postChangePassword(tOldPass, tNewPass, tToken));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
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
          .thenThrow(ServerException());
      // act
      final result = await repository.postFCMToken(tId, tToken);
      // assert
      verify(mockRemoteDataSource.postFcmToken(tId.toString(), tToken));
      expect(result, equals(Left(ServerFailure('Cant To Send'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.postFcmToken(tId.toString(), tToken))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.postFCMToken(tId, tToken);
      // assert
      verify(mockRemoteDataSource.postFcmToken(tId.toString(), tToken));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
  group('Post Login', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.postLogin(tUsername, tOldPass))
          .thenAnswer((_) async => testLogin);
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
          .thenThrow(ServerException());
      // act
      final result = await repository.postLogin(tUsername, tOldPass);
      // assert
      verify(mockRemoteDataSource.postLogin(tUsername, tOldPass));
      expect(
          result, equals(Left(ServerFailure('UserName atau Password Salah!'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.postLogin(tUsername, tOldPass))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.postLogin(tUsername, tOldPass);
      // assert
      verify(mockRemoteDataSource.postLogin(tUsername, tOldPass));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
  group('Post Register', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.postRegister(testRegister))
          .thenAnswer((_) async => testRegisterCallback);
      // act
      final result = await repository.postRegister(testRegister);
      // assert
      verify(mockRemoteDataSource.postRegister(testRegister));
      expect(result, equals(Right(testRegisterCallback)));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
          when(mockRemoteDataSource.postRegister(testRegister))
          .thenThrow(ServerException());
      // act
      final result = await repository.postRegister(testRegister);
      // assert
      verify(mockRemoteDataSource.postRegister(testRegister));
      expect(result, equals(Left(ServerFailure('Invalid Data'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.postRegister(testRegister))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.postRegister(testRegister);
      // assert
      verify(mockRemoteDataSource.postRegister(testRegister));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
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
          .thenThrow(ServerException());
      // act
      final result = await repository.postReport(tToken, tReportCompose);
      // assert
      verify(mockRemoteDataSource.postReport(tToken, tReportCompose));
      expect(result, equals(Left(ServerFailure('Invalid'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.postReport(tToken, tReportCompose))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.postReport(tToken, tReportCompose);
      // assert
      verify(mockRemoteDataSource.postReport(tToken, tReportCompose));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
  group('Post User Challenge', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
          when(mockRemoteDataSource.postChallenge(testUserChallenge))
          .thenAnswer((_) async => 'Success');
      // act
      final result = await repository.postUserChallenge(testUserChallenge);
      // assert
      verify(mockRemoteDataSource.postChallenge(testUserChallenge));
      expect(result, equals(Right('Success')));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
          when(mockRemoteDataSource.postChallenge(testUserChallenge))
          .thenThrow(ServerException());
      // act
      final result = await repository.postUserChallenge(testUserChallenge);
      // assert
      verify(mockRemoteDataSource.postChallenge(testUserChallenge));
      expect(result, equals(Left(ServerFailure('Invalid'))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.postChallenge(testUserChallenge))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.postUserChallenge(testUserChallenge);
      // assert
      verify(mockRemoteDataSource.postChallenge(testUserChallenge));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
  group('Remove Feed', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeFeed(testFeedTable))
          .thenAnswer((_) async => 'Removed from Feed');
      // act
      final result = await repository.removeFeed(testFeed);
      // assert
      expect(result, Right('Removed from Feed'));
    });
    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeFeed(testFeedTable))
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
      expect(result, Right('Session Removed'));
    });
  });
  group('Save Feed', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertFeed(testFeedTable))
          .thenAnswer((_) async => 'Feed Saved');
      // act
      final result = await repository.saveFeed(testFeed);
      // assert
      expect(result, Right('Feed Saved'));
    });
    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertFeed(testFeedTable))
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
      when(mockLocalDataSource.insertSession(testSessionData))
          .thenAnswer((_) async => 'Session Saved');
      // act
      final result = await repository.saveSessionData(testSessionData);
      // assert
      expect(result, Right('Session Saved'));
    });
  });
}
