import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:laporhoax/data/models/feed_response.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const baseUrl = 'https://laporhoaxpolda.herokuapp.com';

  late Dio dio;
  late DioAdapter dioAdapter;
//  late RemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  Response<dynamic> response;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dioAdapter = DioAdapter(dio: dio);
    mockDio = MockDio();
  });

  group('get feeds', () {
    final data = jsonDecode(readJson('dummy_data/feed.json'));
    const feedsEndpoint = 'api/feeds';
    test('should get list of feeds when response status code 200', () async {
      // arrange
      dioAdapter.onGet(
        feedsEndpoint,
        (server) => server.reply(200, data),
      );
      // act
      response = await dio.get(feedsEndpoint);
      // assert
      expect(response.statusCode, 200);
      expect(FeedResponse.fromJson(response.data).feedList, testFeedModelList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      dioAdapter.onGet(
        feedsEndpoint,
        (server) => server.throws(
          404,
          DioError(
            requestOptions: RequestOptions(
              path: feedsEndpoint,
            ),
          ),
        ),
      );
      // act
      // assert
      expect(
        () async => await dio.get(feedsEndpoint),
        throwsA(isA<DioError>()),
      );
    });
  });

  group('get reports', () {
    const reportsEndpoint = 'api/reports';
  });

  group('get category', () {
    const reportCatEndpoint = 'api/reports/cat';
  });

  group('get question', () {
    const questionEndpoint = 'auth/api/question';
  });

  group('get user', () {
    const getUserEndpint = 'auth/api/users/get';
  });

  group('post login', () {
    const loginEndpoint = 'auth/api/login';
  });

  group('post register', () {
    const registerEndpoint = 'auth/api/register';
  });

  group('post token', () {
    const firebaseTokenEndpoint = 'auth/api/fcmToken';
  });

  group('change password', () {
    const passwordChangeEndpoint = 'auth/api/change-password';
  });

  group('reset password', () {
    const passwordResetEndpoint = 'auth/api/reset';
  });
}
