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

  late RemoteDataSourceImpl datasource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    datasource = RemoteDataSourceImpl(dio: mockDio);
  });
}
