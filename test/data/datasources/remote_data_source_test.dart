/*
 * Created by andii on 14/11/21 01.40
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 01.27
 */

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/utils/network_exceptions.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late MockDioClient client;
  late RemoteDataSourceImpl datasource;

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

    test('should return error when feeds unsuccessfully fetched', () async {
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

  group('post login', () {
    // TODO const loginEndpoint = 'auth/api/login';
  });

  group('post register', () {
    // TODO const registerEndpoint = 'auth/api/register';
  });

  group('post token', () {
    // TODO const firebaseTokenEndpoint = 'auth/api/fcmToken';
  });

  group('change password', () {
    // TODO const passwordChangeEndpoint = 'auth/api/change-password';
  });

  group('reset password', () {
    // TODO const passwordResetEndpoint = 'auth/api/reset';
  });
}
