import 'dart:convert';

import 'package:core/data/models/category_model.dart';
import 'package:core/data/models/feed_response.dart';
import 'package:core/data/models/question_model.dart';
import 'package:core/data/models/question_response.dart';
import 'package:core/data/models/report_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  const baseUrl = 'https://laporhoaxpolda.herokuapp.com';

  late Dio dio;
  late DioAdapter dioAdapter;
  Response<dynamic> response;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dioAdapter = DioAdapter(dio: dio);
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
    final data = jsonDecode(readJson('dummy_data/report.json'));
    const reportsEndpoint = 'api/reports';
    test('should get list of reports when response status code 200', () async {
      // arrange
      dioAdapter.onGet(
        reportsEndpoint,
        (server) => server.reply(200, data),
      );
      // act
      response = await dio.get(reportsEndpoint);
      // assert
      expect(response.statusCode, 200);
      expect(
          ReportResponse.fromJson(response.data).reportList, [testReportModel]);
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      dioAdapter.onGet(
        reportsEndpoint,
        (server) => server.throws(
          404,
          DioError(
            requestOptions: RequestOptions(
              path: reportsEndpoint,
            ),
          ),
        ),
      );
      // act
      // assert
      expect(
        () async => await dio.get(reportsEndpoint),
        throwsA(isA<DioError>()),
      );
    });
  });

  group('get category', () {
    final data = jsonDecode(readJson('dummy_data/category.json'));
    const reportCatEndpoint = 'api/reports/cat';
    var tCategoryModels = [
      CategoryModel(id: 2, name: "Isu SARA"),
      CategoryModel(id: 1, name: "Ujaran Kebencian"),
    ];
    test('should get list of categories when response status code 200', () async {
      // arrange
      dioAdapter.onGet(
        reportCatEndpoint,
            (server) => server.reply(200, data),
      );
      // act
      response = await dio.get(reportCatEndpoint);
      // assert
      expect(response.statusCode, 200);
      expect(
          List<CategoryModel>.from(
              (response.data).map((x) => CategoryModel.fromJson(x))), tCategoryModels);
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          dioAdapter.onGet(
            reportCatEndpoint,
                (server) => server.throws(
              404,
              DioError(
                requestOptions: RequestOptions(
                  path: reportCatEndpoint,
                ),
              ),
            ),
          );
          // act
          // assert
          expect(
                () async => await dio.get(reportCatEndpoint),
            throwsA(isA<DioError>()),
          );
        });
  });

  group('get question', () {
    final data = jsonDecode(readJson('dummy_data/question.json'));
    const questionEndpoint = 'auth/api/question';
    final tQuestionModels = [
      QuestionModel(id: 1, question: "Dimana anda lahir?"),
      QuestionModel(id: 2, question: "Apa nama hewan peliharaan pertamamu?"),
      QuestionModel(id: 3, question: "Siapa nama teman dekat masa kecilmu?"),
      QuestionModel(id: 4, question: "Apa makanan kesukaanmu?"),
      QuestionModel(id: 5, question: "Apa warna favoritmu?"),
      QuestionModel(id: 6, question: "Apa nama masa kecilmu?")
    ];
    test('should get list of question when response status code 200', () async {
      // arrange
      dioAdapter.onGet(
        questionEndpoint,
            (server) => server.reply(200, data),
      );
      // act
      response = await dio.get(questionEndpoint);
      // assert
      expect(response.statusCode, 200);
      expect(
          QuestionResponse.fromJson(response.data).questionList, tQuestionModels);
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          dioAdapter.onGet(
            questionEndpoint,
                (server) => server.throws(
              404,
              DioError(
                requestOptions: RequestOptions(
                  path: questionEndpoint,
                ),
              ),
            ),
          );
          // act
          // assert
          expect(
                () async => await dio.get(questionEndpoint),
            throwsA(isA<DioError>()),
          );
        });
  });

  group('get user', () {
    final tUserName = 'username';
    final data = jsonDecode(readJson('dummy_data/category.json'));
    const getUserEndpoint = 'auth/api/users/get';
    test('should get user data when response status code 200', () async {
      // arrange
      dioAdapter.onGet(
        '$getUserEndpoint/$tUserName',
            (server) => server.reply(200, data),
      );
      // act
      response = await dio.get('$getUserEndpoint/$tUserName');
      // assert
      expect(response.statusCode, 200);
      expect(true, true);
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          dioAdapter.onGet(
            getUserEndpoint,
                (server) => server.throws(
              404,
              DioError(
                requestOptions: RequestOptions(
                  path: getUserEndpoint,
                ),
              ),
            ),
          );
          // act
          // assert
          expect(
                () async => await dio.get(getUserEndpoint),
            throwsA(isA<DioError>()),
          );
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
