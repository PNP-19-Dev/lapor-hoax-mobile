import 'package:core/data/models/register_model.dart';
import 'package:core/data/models/user_response.dart';
import 'package:core/domain/entities/session_data.dart';
import 'package:core/domain/usecases/get_password_reset.dart';
import 'package:core/domain/usecases/get_session_data.dart';
import 'package:core/domain/usecases/get_session_status.dart';
import 'package:core/domain/usecases/get_user.dart';
import 'package:core/domain/usecases/post_change_password.dart';
import 'package:core/domain/usecases/post_fcm_token.dart';
import 'package:core/domain/usecases/post_login.dart';
import 'package:core/domain/usecases/post_register.dart';
import 'package:core/domain/usecases/post_user_challenge.dart';
import 'package:core/domain/usecases/put_fcm_token.dart';
import 'package:core/domain/usecases/remove_session_data.dart';
import 'package:core/domain/usecases/save_session_data.dart';
import 'package:core/presentation/provider/user_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'user_notifier_test.mocks.dart';

@GenerateMocks([
  GetUser,
  PostLogin,
  PostRegister,
  GetPasswordReset,
  GetSessionData,
  PostFCMToken,
  PutFCMToken,
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
  late MockPutFCMToken mockPutFCMToken;
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
    mockPutFCMToken = MockPutFCMToken();

    provider = UserNotifier(
      getUser: mockGetUser,
      getPasswordReset: mockGetPasswordReset,
      getSessionData: mockGetSessionData,
      postFCMToken: mockPostFCMToken,
      putFCMToken: mockPutFCMToken,
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

  final tId = 1;
  final tToken = 'token';
  final tEmail = 'email';
  final tOldPass = 'oldPass';
  final tNewPass = 'newPass';
  final tSessionData = SessionData(
    token: "token",
    userid: 1,
    expiry: "expiry",
    email: "email",
    username: "username",
  );
  final tRegisterModel = RegisterModel(
    name: "name",
    email: "email",
    password: "password",
  );
  final tUserResponse = UserResponse(user: testUserModel, token: tToken);

  group('GetUser', () {
    test('should change user data when data is gotten successfully', () async {
      // arrange
      when(mockGetUser.execute(tEmail))
          .thenAnswer((_) async => Right(testUser));
      // act
      await provider.getUserData(tEmail);
      // assert
      expect(provider.userState, RequestState.loaded);
      expect(provider.user, testUser);
      expect(listenerCallCount, 2);
    });
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetUser.execute(tEmail))
          .thenAnswer((_) async => Left(ServerFailure("Can't get data")));
      // act
      await provider.getUserData(tEmail);
      // assert
      expect(provider.userState, RequestState.error);
      expect(provider.userMessage, "Can't get data");
      expect(listenerCallCount, 1);
    });
  });
  group('GetPasswordReset', () {
    test('should return callback when data is gotten successfully', () async {
      // arrange
      when(mockGetPasswordReset.execute(tEmail))
          .thenAnswer((_) async => Right('Success'));
      // act
      await provider.reset(tEmail);
      // assert
      expect(provider.resetMessage, UserNotifier.messageReset);
      expect(listenerCallCount, 1);
    });
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPasswordReset.execute(tEmail))
          .thenAnswer((_) async => Left(ServerFailure("Can't get data")));
      // act
      await provider.reset(tEmail);
      // assert
      expect(provider.resetMessage, "Can't get data");
      expect(listenerCallCount, 1);
    });
  });
  group('GetSessionData', () {
    test('should change session data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetSessionData.execute())
          .thenAnswer((_) async => Right(tSessionData));
      // act
      await provider.getSession();
      // assert
      expect(provider.sessionData, tSessionData);
      expect(listenerCallCount, 1);
    });
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetSessionData.execute())
          .thenAnswer((_) async => Left(CustomException("Can't get data")));
      // act
      await provider.getSession();
      // assert
      expect(provider.sessionMessage, "Can't get data");
      expect(listenerCallCount, 1);
    });
  });
  group('PostFCMToken', () {
    test('should return callback when data is gotten successfully', () async {
      // arrange
      when(mockPostFCMToken.execute(tId, tToken))
          .thenAnswer((_) async => Right("Success"));
      // act
      await provider.postToken(tId, tToken);
      // assert
      expect(provider.fcmMessage, "Success");
      expect(listenerCallCount, 2);
    });
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockPostFCMToken.execute(tId, tToken))
          .thenAnswer((_) async => Left(ServerFailure("Can't get data")));
      // act
      await provider.postToken(tId, tToken);
      // assert
      expect(provider.fcmMessage, "Can't get data");
      expect(listenerCallCount, 1);
    });
  });

  group('PutFCMToken', () {
    test('should return callback when data is gotten successfully', () async {
      // arrange
      when(mockPutFCMToken.execute(tId, tToken))
          .thenAnswer((_) async => Right("Success"));
      // act
      await provider.putToken(tId, tToken);
      // assert
      expect(provider.fcmMessage, "Success");
      expect(listenerCallCount, 2);
    });
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockPutFCMToken.execute(tId, tToken))
          .thenAnswer((_) async => Left(ServerFailure("Can't get data")));
      // act
      await provider.putToken(tId, tToken);
      // assert
      expect(provider.fcmMessage, "Can't get data");
      expect(listenerCallCount, 1);
    });
  });

  group('PostChangePassword', () {
    test('should return callback when data is gotten successfully', () async {
      // arrange
      when(mockPostChangePassword.execute(tOldPass, tNewPass, tToken))
          .thenAnswer((_) async => Right(UserNotifier.messageChangePassword));
      // act
      await provider.changePassword(tOldPass, tNewPass, tToken);
      // assert
      expect(
          provider.passwordChangeMessage, UserNotifier.messageChangePassword);
      expect(listenerCallCount, 1);
    });
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockPostChangePassword.execute(tOldPass, tNewPass, tToken))
          .thenAnswer((_) async => Left(ServerFailure("Can't get data")));
      // act
      await provider.changePassword(tOldPass, tNewPass, tToken);
      // assert
      expect(provider.passwordChangeMessage, "Can't get data");
      expect(listenerCallCount, 1);
    });
  });
  group('PostUserChallenge', () {
    test('should return callback when data is gotten successfully', () async {
      // arrange
      when(mockPostUserChallenge.execute(testUserChallenge))
          .thenAnswer((_) async => Right(UserNotifier.messageQuestion));
      // act
      await provider.postChallenge(testUserChallenge);
      // assert
      expect(provider.challengeMessage, UserNotifier.messageQuestion);
      expect(listenerCallCount, 1);
    });
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockPostUserChallenge.execute(testUserChallenge))
          .thenAnswer((_) async => Left(ServerFailure("Invalid")));
      // act
      await provider.postChallenge(testUserChallenge);
      // assert
      expect(provider.challengeMessage, "Invalid");
      expect(listenerCallCount, 1);
    });
  });
  group('Login', () {
    test('should return callback when data is gotten successfully', () async {
      /*  // arrange
      when(mockPostLogin.execute(tUsername, tOldPass))
          .thenAnswer((_) async => Right(tUserToken));
      when(mockGetUser.execute(tUsername))
          .thenAnswer((_) async => Right(testUser));
      when(mockSaveSessionData.execute(testSessionData))
          .thenAnswer((_) async => Right(UserNotifier.messageLogin));
      // act
      final result = await provider.login(tUsername, tOldPass);
      // assert
      expect(provider.loginState, RequestState.Success);
      expect(provider.loginMessage, UserNotifier.messageLogin);
      expect(listenerCallCount, 1);*/
    });
    test('should return error when data is unsuccessful', () async {
      /* // arrange
      when(mockPostLogin.execute(tUsername, tOldPass))
          .thenAnswer((_) async => Left(ServerFailure('invalid')));
      // act
      await provider.login(tUsername, tOldPass);
      // assert
      expect(provider.loginState, RequestState.Error);
      expect(provider.loginMessage, 'invalid');
      expect(listenerCallCount, 1);*/
    });
  });

  group('PostRegister', () {
    test('should return callback when data is gotten successfully', () async {
      // arrange
      when(mockPostRegister.execute(tRegisterModel))
          .thenAnswer((_) async => Right(tUserResponse));
      // act
      await provider.register(tRegisterModel);
      // assert
      expect(provider.registerState, RequestState.loaded);
      expect(provider.userResponse, tUserResponse);
      expect(listenerCallCount, 2);
    });
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockPostRegister.execute(tRegisterModel))
          .thenAnswer((_) async => Left(ServerFailure("Invalid")));
      // act
      await provider.register(tRegisterModel);
      // assert
      expect(provider.registerState, RequestState.error);
      expect(provider.registerMessage, "Invalid");
      expect(listenerCallCount, 1);
    });
  });
}
