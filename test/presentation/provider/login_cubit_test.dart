/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.59
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/remove_session_data.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'login_cubit_test.mocks.dart';

@GenerateMocks([
  PostLogin,
  GetUser,
  SaveSessionData,
  GetSessionData,
  RemoveSessionData,
])
void main() {
  late LoginCubit bloc;
  late MockPostLogin _login;
  late MockGetUser _user;
  late MockSaveSessionData _save;
  late MockGetSessionData _data;
  late MockRemoveSessionData _logout;

  setUp(() {
    _login = MockPostLogin();
    _user = MockGetUser();
    _save = MockSaveSessionData();
    _logout = MockRemoveSessionData();
    _data = MockGetSessionData();
    bloc = LoginCubit(_login, _user, _save, _data, _logout);
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
        return bloc;
      },
      act: (bloc) => bloc.login(username, password),
      verify: (bloc) => bloc.login(username, password),
      expect: () => <LoginState>[
        Login(),
        SessionSaving(testSessionData),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'Should return success callback when login',
      build: () {
        when(_save.execute(testSessionData))
            .thenAnswer((_) async => LocalDataSource.saveMessage);
        return bloc;
      },
      act: (bloc) => bloc.savingSession(testSessionData),
      verify: (bloc) => bloc.savingSession(testSessionData),
      expect: () => <LoginState>[
        LoginSuccess(),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'Should return error callback when login is unsuccessful',
      build: () {
        when(_login.execute(username, password))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        when(_user.execute(username))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
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
      'Should return error callback when login is unsuccessful #2',
      build: () {
        when(_login.execute(username, password))
            .thenAnswer((_) async => Right(testLogin));
        when(_user.execute(username))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
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
        LoginInitial(),
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
        LoginInitial(),
        LoginEnded(),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'Should return error callback when session failure',
      build: () {
        when(_data.execute()).thenAnswer((_) async => Left(CustomException('No Data')));
        return bloc;
      },
      act: (bloc) => bloc.fetchSession(),
      verify: (bloc) => bloc.fetchSession(),
      expect: () => <LoginState>[
        LoginInitial(),
        LoginFailure('No Data'),
      ],
    );
  });

  group('logout', () {
    blocTest<LoginCubit, LoginState>(
      'Should return success callback when logout',
      build: () {
        when(_logout.execute(testSessionData))
            .thenAnswer((_) async => LocalDataSource.logoutMessage);
        return bloc;
      },
      act: (bloc) => bloc.logout(testSessionData),
      verify: (bloc) => bloc.logout(testSessionData),
      expect: () => <LoginState>[
        LoginEnded(),
      ],
    );
  });
}
