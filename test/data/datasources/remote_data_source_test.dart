
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';

import '../../helpers/test_helper.mocks.dart';

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
  const feedsEndpoint = 'api/feeds';
  const isActiveEndpoint = 'isactive';
  const verifyOtpEndpoint = 'verifyotp';

  late RemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = RemoteDataSourceImpl(dio: mockDio);
  });

  group('get feeds', () {
  /*  test('should return list of feeds when response is success (200)',
        () async {
      final data = jsonEncode(readJson('dummy_data/feed.json'));

      final response = Response(
          requestOptions: RequestOptions(path: '$baseUrl/$feedsEndpoint'),
          statusCode: 200,
          data: data);

      // arrange
      when(mockDio.fetch(
              RequestOptions(path: '$baseUrl/$feedsEndpoint', method: 'GET')))
          .thenAnswer((_) async => response);
      // act
      final result = await dataSource.getFeeds();
      // assert
      expect(result, testFeedList);
    });*/
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
