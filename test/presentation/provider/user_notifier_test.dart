import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_password_reset.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_session_status.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';
import 'package:laporhoax/domain/usecases/post_fcm_token.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';
import 'package:laporhoax/domain/usecases/remove_session_data.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';
import 'package:laporhoax/presentation/provider/user_notifier.dart';
import 'package:mockito/annotations.dart';

import 'user_notifier_test.mocks.dart';

@GenerateMocks([
  GetUser,
  PostLogin,
  PostRegister,
  GetPasswordReset,
  GetSessionData,
  PostFCMToken,
  PostChangePassword,
  PostUserChallenge,
  RemoveSessionData,
  SaveSessionData,
  GetSessionStatus,
])
void main() {
  late UserNotifier provider;
  late MockGetUser mockGetUser;
  late MockPostLogin mockPostLogin;
  late MockPostRegister mockPostRegister;
  late MockGetPasswordReset mockGetPasswordReset;
  late MockGetSessionData mockGetSessionData;
  late MockPostFCMToken mockPostFCMToken;
  late MockPostChangePassword mockPostChangePassword;
  late MockPostUserChallenge mockPostUserChallenge;
  late MockRemoveSessionData mockRemoveSessionData;
  late MockSaveSessionData mockSaveSessionData;
  late MockGetSessionStatus mockGetSessionStatus;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetUser = MockGetUser();
    mockPostLogin = MockPostLogin();
    mockPostRegister = MockPostRegister();
    mockGetPasswordReset = MockGetPasswordReset();
    mockGetSessionData = MockGetSessionData();
    mockPostFCMToken = MockPostFCMToken();
    mockPostChangePassword = MockPostChangePassword();
    mockPostUserChallenge = MockPostUserChallenge();
    mockRemoveSessionData = MockRemoveSessionData();
    mockGetSessionStatus = MockGetSessionStatus();
    mockSaveSessionData = MockSaveSessionData();
    mockGetSessionData = MockGetSessionData();
    provider = UserNotifier(
      getUser: mockGetUser,
      getPasswordReset: mockGetPasswordReset,
      getSessionData: mockGetSessionData,
      postFCMToken: mockPostFCMToken,
      postChangePassword: mockPostChangePassword,
      postUserChallenge: mockPostUserChallenge,
      saveSessionData: mockSaveSessionData,
      removeSessionData: mockRemoveSessionData,
      getSessionStatus: mockGetSessionStatus,
      postLogin: mockPostLogin,
      postRegister: mockPostRegister,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });
}
