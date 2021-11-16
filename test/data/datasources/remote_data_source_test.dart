/*
 * Created by andii on 16/11/21 09.46
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 09.07
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/utils/network_exceptions.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late MockDioClient client;
  late RemoteDataSourceImpl datasource;
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    client = MockDioClient();
    datasource = RemoteDataSourceImpl(client: client);
  });

  group('get feeds', () {
    test('should return feeds when feeds successfully fetched', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/feed.json'));
      when(client.get('/$feedsEndpoint/')).thenAnswer((_) async => jsonMap);
      // act
      final result = await datasource.getFeeds();
      // assert
      expect(result, [testFeedModel]);
    });

    test('should return error when feeds unsuccessfully fetched', () async {
      // arrange
      when(client.get('/$feedsEndpoint/')).thenThrow(DioError(
          requestOptions: RequestOptions(path: '/$feedsEndpoint/'),
          type: DioErrorType.other));
      // act
      final result = datasource.getFeeds();
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('get feed detail', () {
    const id = 27;
    test('should return detail of feed when data successfully fetched',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/detail.json'));
      when(client.get('/$feedsEndpoint/$id')).thenAnswer((_) async => jsonMap);
      // act
      final result = await datasource.getFeedDetail(id);
      // assert
      expect(result, testFeedModel);
    });

    test('should return error when detail unsuccessfully fetched', () async {
      // arrange
      when(client.get('/$feedsEndpoint/$id')).thenThrow(DioError(
          requestOptions: RequestOptions(path: '/$feedsEndpoint/$id'),
          type: DioErrorType.other));
      // act
      final result = datasource.getFeedDetail(id);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('get reports', () {
    const id = 1;
    const token = 'token';

    test('should return reports when report successfully fetched', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/report.json'));
      when(client.get(
        '/$reportsEndpoint/user/$id/',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        },
      )).thenAnswer((_) async => jsonMap);
      // act
      final result = await datasource.getReport(token, id);
      // assert
      expect(result, [testReportModel]);
    });

    test('should return error when reports unsuccessfully fetched', () async {
      // arrange
      when(
        client.get(
          '/$reportsEndpoint/user/$id',
          headers: {
            HttpHeaders.authorizationHeader: "Token $token",
          },
        ),
      ).thenThrow(DioError(
          requestOptions:
              RequestOptions(path: '/$reportsEndpoint/user/$id', headers: {
            HttpHeaders.authorizationHeader: "Token $token",
          }),
          type: DioErrorType.other));
      // act
      final result = datasource.getReport(token, id);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('get category', () {
    test('should return categories when categories successfully fetched',
        () async {
      // arrange
      when(client.get('/$reportCatEndpoint'))
          .thenAnswer((_) async => [testCategoryMap]);
      // act
      final result = await datasource.getCategory();
      // assert
      expect(result, [testCategoryModel]);
    });

    test('should return error when categories unsuccessfully fetched',
        () async {
      // arrange
      when(client.get('/$reportCatEndpoint/')).thenThrow(DioError(
          requestOptions: RequestOptions(path: '/$reportCatEndpoint/'),
          type: DioErrorType.other));
      // act
      final result = datasource.getCategory();
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('get question', () {
    test('should return question when question successfully fetched', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/question.json'));
      when(client.get('/$questionEndpoint')).thenAnswer((_) async => jsonMap);
      // act
      final result = await datasource.getQuestions();
      // assert
      expect(result, [testQuestionModel]);
    });

    test('should return error when question unsuccessfully fetched', () async {
      // arrange
      when(client.get('/$questionEndpoint')).thenThrow(DioError(
          requestOptions: RequestOptions(path: '/$questionEndpoint'),
          type: DioErrorType.other));
      // act
      final result = datasource.getQuestions();
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('get user', () {
    const email = 'email';

    test('should return userdata when user successfully fetched', () async {
      // arrange
      when(client.get(
        '/$getUserEndpoint',
        headers: {"email": email},
      )).thenAnswer((_) async => [testUserMap]);
      // act
      final result = await datasource.getUser(email);
      // assert
      expect(result, testUserModel);
    });

    test('should return error when user unsuccessfully fetched', () async {
      // arrange
      when(
        client.get(
          '/$getUserEndpoint',
          headers: {"email": email},
        ),
      ).thenThrow(DioError(
          requestOptions: RequestOptions(
            path: '/$getUserEndpoint',
            headers: {"email": email},
          ),
          type: DioErrorType.other));
      // act
      final result = datasource.getUser(email);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('get password reset', () {
    const email = 'email';
    test('should return reset callback when data successfully fetched',
        () async {
      // arrange
      final dynamic jsonMap = json.decode(readJson('dummy_data/reset.json'));
      when(client.get('/$passwordResetEndpoint/$email'))
          .thenAnswer((_) async => jsonMap);
      // act
      final result = await datasource.getPasswordReset(email);
      // assert
      expect(result, "Success");
    });

    test('should return error when reset unsuccessful', () async {
      // arrange
      when(client.get('/$passwordResetEndpoint/$email')).thenThrow(DioError(
          requestOptions:
              RequestOptions(path: '/$passwordResetEndpoint/$email'),
          type: DioErrorType.other));
      // act
      final result = datasource.getPasswordReset(email);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('get user questions', () {
    const id = 1;

    test("should return user's question when report successfully fetched",
        () async {
      // arrange
      final dynamic jsonMap =
          json.decode(readJson('dummy_data/user-question.json'));
      when(client.get('/$questionEndpoint/user/$id'))
          .thenAnswer((_) async => jsonMap);
      // act
      final result = await datasource.getUserQuestions(id);
      // assert
      expect(result, testUserChallengeFromJson);
    });

    test('should return error when question unsuccessfully fetched', () async {
      // arrange
      when(client.get('/$questionEndpoint/user/$id')).thenThrow(DioError(
          requestOptions: RequestOptions(path: '/$questionEndpoint/user/$id'),
          type: DioErrorType.other));
      // act
      final result = datasource.getUserQuestions(id);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('post login', () {
    const username = 'username';
    const password = 'password';
    const data = {"username": username, "password": password};

    test('should return token session when login successfully fetched',
        () async {
      // arrange
      final dynamic jsonMap = json.decode(readJson('dummy_data/token.json'));
      when(client.post('/$loginEndpoint/', data: data))
          .thenAnswer((_) async => jsonMap);
      // act
      final result = await datasource.postLogin(username, password);
      // assert
      expect(result, testLoginModel);
    });

    test('should return error when login unsuccessful', () async {
      // arrange
      when(client.post('/$loginEndpoint/')).thenThrow(DioError(
          requestOptions: RequestOptions(path: '/$loginEndpoint/', data: data),
          type: DioErrorType.other));
      // act
      final result = datasource.postLogin(username, password);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('post register', () {
    const username = 'username';
    const password = 'password';
    final user = testRegisterModel;

    test('should return token session when register successfully fetched',
        () async {
      // arrange
      final dynamic jsonMap = json.decode(readJson('dummy_data/register.json'));
      when(client.post('/$registerEndpoint/', data: user.toJson()))
          .thenAnswer((_) async => jsonMap);
      // act
      final result = await datasource.postRegister(user);
      // assert
      expect(result, testRegisterCallback);
    });

    test('should return error when login unsuccessful', () async {
      // arrange
      when(client.post('/$registerEndpoint/', data: user.toJson())).thenThrow(
          DioError(
              requestOptions: RequestOptions(
                  path: '/$registerEndpoint/', data: user.toJson()),
              type: DioErrorType.other));
      // act
      final result = datasource.postLogin(username, password);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('post token', () {
    const user = 'user';
    const fcmToken = 'token';
    const data = {'user': user, 'token': fcmToken};

    test('should return success when token successfully sent', () async {
      // arrange
      when(client.post('/$firebaseTokenEndpoint', data: data))
          .thenAnswer((_) async => 'Success');
      // act
      final result = await datasource.postFcmToken(user, fcmToken);
      // assert
      expect(result, 'Success');
    });

    test('should return error when post token unsuccessful', () async {
      // arrange
      when(client.post('/$firebaseTokenEndpoint')).thenThrow(DioError(
          requestOptions:
              RequestOptions(path: '/$firebaseTokenEndpoint', data: data),
          type: DioErrorType.other));
      // act
      final result = datasource.postFcmToken(user, fcmToken);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('post report', () {
    const token = 'token';

    /*    test('should return report detail when report sent successfully', () async {
      ByteData imageData = await rootBundle.load('assets/icons/ans.png');
      Uint8List imageAsBytes = imageData.buffer.asUint8List();
      final report = ReportRequest(
        user: 1,
        url: 'url',
        category: 'category',
        isAnonym: false,
        description: 'description',
        img: XFile.fromData(imageAsBytes),
      );

      // arrange
      final data = FormData.fromMap({
        'user': report.user.toString(),
        'url': report.url,
        'category': report.category,
        'isAnonym': report.isAnonym.toString(),
        'description': report.description,
        'img': MultipartFile.fromBytes(imageAsBytes),
      });

      final dynamic jsonMap = json.decode(readJson('dummy_data/report.json'));
      when(client.post('/$reportsEndpoint/',
              data: data,
              headers: {HttpHeaders.authorizationHeader: "Token $token"}))
          .thenAnswer((_) async => jsonMap);
      // act
      final result = await datasource.postReport(token, report);
      // assert
      expect(result, testReportModel);
    });*/

    test('should return error when post report unsuccessful', () async {
      ByteData imageData = await rootBundle.load('assets/icons/ans.png');
      Uint8List imageAsBytes = imageData.buffer.asUint8List();
      final report = ReportRequest(
        user: 1,
        url: 'url',
        category: 'category',
        isAnonym: false,
        description: 'description',
        img: XFile.fromData(imageAsBytes),
      );

      // arrange
      final data = FormData.fromMap({
        'user': report.user.toString(),
        'url': report.url,
        'category': report.category,
        'isAnonym': report.isAnonym.toString(),
        'description': report.description,
        'img': MultipartFile.fromBytes(imageAsBytes),
      });

      when(client.post('/$reportsEndpoint/',
              data: data,
              headers: {HttpHeaders.authorizationHeader: "Token $token"}))
          .thenThrow(DioError(
              requestOptions: RequestOptions(
                  path: '/$reportsEndpoint/',
                  data: data,
                  headers: {HttpHeaders.authorizationHeader: "Token $token"}),
              type: DioErrorType.other));
      // act
      final result = datasource.postReport(token, report);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('post challenge', () {
    final challenge = testUserChallengeModel;
    test('should return success when answers successfully sent', () async {
      // arrange
      when(client.post('/$questionEndpoint/user/', data: challenge.toJson()))
          .thenAnswer((_) async => 'Success');
      // act
      final result = await datasource.postChallenge(challenge);
      // assert
      expect(result, 'Success');
    });

    test('should return error when post answers unsuccessful', () async {
      // arrange
      when(client.put('/$questionEndpoint/user/', data: challenge.toJson()))
          .thenThrow(DioError(
              requestOptions: RequestOptions(
                  path: '/$questionEndpoint/user/', data: challenge.toJson()),
              type: DioErrorType.other));
      // act
      final result = datasource.postChallenge(challenge);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('put password', () {
    const oldPass = 'oldPass';
    const newPass = 'newPass';
    const token = 'token';
    const data = {'old_password': oldPass, 'new_password': newPass};

    test('should return success when password has changed', () async {
      // arrange
      when(client.put('/$passwordChangeEndpoint/',
              data: data,
              headers: {HttpHeaders.authorizationHeader: "Token $token"}))
          .thenAnswer((_) async => 'Success');
      // act
      final result = await datasource.putPassword(oldPass, newPass, token);
      // assert
      expect(result, 'Success');
    });

    test('should return error when change password unsuccessful', () async {
      // arrange
      when(client.put('/$passwordChangeEndpoint/',
              data: data,
              headers: {HttpHeaders.authorizationHeader: "Token $token"}))
          .thenThrow(DioError(
              requestOptions: RequestOptions(
                  path: '/$passwordChangeEndpoint/',
                  data: data,
                  headers: {HttpHeaders.authorizationHeader: "Token $token"}),
              type: DioErrorType.other));
      // act
      final result = datasource.putPassword(oldPass, newPass, token);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('put token', () {
    const user = 'user';
    const fcmToken = 'token';
    const data = {'user': user, 'token': fcmToken};

    test('should return success when token successfully sent', () async {
      // arrange
      when(client.put('/$firebaseTokenEndpoint', data: data))
          .thenAnswer((_) async => 'Success');
      // act
      final result = await datasource.putFcmToken(user, fcmToken);
      // assert
      expect(result, 'Success');
    });

    test('should return error when post token unsuccessful', () async {
      // arrange
      when(client.put('/$firebaseTokenEndpoint')).thenThrow(DioError(
          requestOptions:
              RequestOptions(path: '/$firebaseTokenEndpoint', data: data),
          type: DioErrorType.other));
      // act
      final result = datasource.putFcmToken(user, fcmToken);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });

  group('delete report', () {
    const token = 'token';
    const id = 1;

    test('should return success when delete successfully fetched', () async {
      // arrange
      when(client.delete('/$reportsEndpoint/$id/', headers: {
        HttpHeaders.authorizationHeader: "Token $token",
      })).thenAnswer((_) async => 'Success');
      // act
      final result = await datasource.deleteReport(token, id);
      // assert
      expect(result, 'Success');
    });

    test('should return error when delete report unsuccessful', () async {
      // arrange
      when(client.delete('/$reportsEndpoint/$id/', headers: {
        HttpHeaders.authorizationHeader: "Token $token",
      })).thenThrow(DioError(
          requestOptions:
              RequestOptions(path: '/$reportsEndpoint/$id/', headers: {
            HttpHeaders.authorizationHeader: "Token $token",
          }),
          type: DioErrorType.other));
      // act
      final result = datasource.deleteReport(token, id);
      // assert
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });
}
