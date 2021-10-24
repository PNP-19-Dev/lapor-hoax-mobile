import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  const baseUrl = 'https://laporhoaxpolda.herokuapp.com';
  const loginEndpoint = 'auth/api/login';
  const registerEndpoint = 'auth/api/register';
  const getUserEndpint = 'auth/api/users/get';
  const questionEndpoint = 'auth/api/question';
  const firebaseTokenEndpoint = 'auth/api/fcmToken';
  const passwordChangeEndpoint = 'auth/api/change-password';
  const passwordResetEndpoint = 'auth/api/reset';

  const reportsEndpoint = 'api/reports';
  const reportCatEndpoint = 'api/reports/cat';
  const isActiveEndpoint = 'isactive';
  const verifyOtpEndpoint = 'verifyotp';

  late Dio dio;
  late DioAdapter dioAdapter;
  late RemoteDataSourceImpl dataSource;
  Response<dynamic> response;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dioAdapter = DioAdapter(dio: dio);
    dataSource = RemoteDataSourceImpl(dio: dioAdapter.dio);
  });

  group('get feeds', () {
    final data = jsonDecode(readJson('dummy_data/feed.json'));
    const feedsEndpoint = 'api/feeds';
    test('should get response status code 200', () async {
      // arrange
      dioAdapter.onGet(
        feedsEndpoint,
        (server) => server.reply(200, data),
      );
      // act
      response = await dio.get(feedsEndpoint);
      // assert
      expect(response.statusCode, 200);
    });

    test('should return list of feeds when response is success (200)',
        () async {
      // arrange
      dioAdapter.onGet(
        feedsEndpoint,
        (server) => server.reply(200, data),
      );
      // act
      // assert
      expect(() async => await dataSource.getFeeds(), testFeedModelList);
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
        () async => await dataSource.getQuestions(),
        throwsA(isA<DioError>()),
      );
    });

    /*test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getPopularMovies();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });*/
  });
}
