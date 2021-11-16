/*
 * Created by andii on 17/11/21 00.28
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 22.55
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/set_session.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'login_cubit_test.mocks.dart';

@GenerateMocks([
  PostLogin,
  GetUser,
  GetSessionData,
  SetSession,
  SessionData,
])
void main() {
  late LoginCubit bloc;
  late MockPostLogin _login;
  late MockGetUser _user;
  late MockSetSession _setSession;
  late MockGetSessionData _data;

  setUp(() {
    _login = MockPostLogin();
    _user = MockGetUser();
    _setSession = MockSetSession();
    _data = MockGetSessionData();
    bloc = LoginCubit(_login, _user, _data, _setSession);
  });

  group('login', () {
    const username = 'username';
    const password = 'password';

    blocTest<LoginCubit, LoginState>(
      'Should return session callback when login',
      build: () {
        when(_login.execute(username, password))
            .thenAnswer((_) async => Right(testLogin));
        when(_user.execute(username)).thenAnswer((_) async => Right(testUser));
        when(_setSession.execute(data: SessionData(
          email: testUser.email,
          expiry: testLogin.expiry!,
          token: testLogin.token!,
          username: testUser.username,
          userid: testUser.id,
        ))).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.login(username, password),
      verify: (bloc) => bloc.login(username, password),
      expect: () => <LoginState>[
        Login(),
        LoginSuccess(),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'Should return session callback when login',
      build: () {
        when(_login.execute(username, password))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        when(_user.execute(username)).thenAnswer((_) async => Left(ServerFailure('Failure')));
        when(_setSession.execute(data: SessionData(
          email: testUser.email,
          expiry: testLogin.expiry!,
          token: testLogin.token!,
          username: testUser.username,
          userid: testUser.id,
        ))).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.login(username, password),
      verify: (bloc) => bloc.login(username, password),
      expect: () => <LoginState>[
        Login(),
        LoginFailure('Failure'),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'Should return session callback when login',
      build: () {
        when(_login.execute(username, password))
            .thenAnswer((_) async => Right(testLogin));
        when(_user.execute(username)).thenAnswer((_) async => Left(ServerFailure('Failure')));
        when(_setSession.execute(data: SessionData(
          email: testUser.email,
          expiry: testLogin.expiry!,
          token: testLogin.token!,
          username: testUser.username,
          userid: testUser.id,
        ))).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.login(username, password),
      verify: (bloc) => bloc.login(username, password),
      expect: () => <LoginState>[
        Login(),
        LoginFailure('Failure'),
      ],
    );
  });

  group('fetch session', () {
    blocTest<LoginCubit, LoginState>(
      'Should return success callback when fetch session data',
      build: () {
        when(_data.execute()).thenAnswer((_) async => Right(testSessionData));
        return bloc;
      },
      act: (bloc) => bloc.fetchSession(),
      verify: (bloc) => bloc.fetchSession(),
      expect: () => <LoginState>[
        LoginSuccessWithData(testSessionData),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'Should return error callback when login is unsuccessful',
      build: () {
        when(_data.execute()).thenAnswer((_) async => Right(null));
        return bloc;
      },
      act: (bloc) => bloc.fetchSession(),
      verify: (bloc) => bloc.fetchSession(),
      expect: () => <LoginState>[
        LoginEnded(),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'Should return error callback when session failure',
      build: () {
        when(_data.execute())
            .thenAnswer((_) async => Left(CustomException('No Data')));
        return bloc;
      },
      act: (bloc) => bloc.fetchSession(),
      verify: (bloc) => bloc.fetchSession(),
      expect: () => <LoginState>[
        LoginFailure('No Data'),
      ],
    );
  });

  group('logout', () {
    blocTest<LoginCubit, LoginState>(
      'Should return success callback when logout',
      build: () {
        when(_setSession.execute())
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.logout(),
      verify: (bloc) => bloc.logout(),
      expect: () => <LoginState>[
        LoginEnded(),
      ],
    );
  });
}
