/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.55
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/remove_session_data.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';

class LoginCubit extends Cubit<LoginState> {
  final PostLogin _login;
  final GetUser _user;
  final SaveSessionData _save;
  final GetSessionData _data;
  final RemoveSessionData _logout;

  LoginCubit(this._login,
      this._user,
      this._save,
      this._data,
      this._logout,) : super(LoginInitial());

  /*TODO UPDATE THE FCM TOKEN
  final data = Provider.of<UserNotifier>(
          context,
          listen: false)
      .user;
  String? token = await FirebaseMessaging
      .instance
      .getToken();
  if (token != null) {
    await Provider.of<UserNotifier>(context,
            listen: false)
        .putToken(data!.id, token);
  }*/

  Future<void> login(String username, String password) async {
    emit(Login());
    final result = await _login.execute(username, password);
    final user = await _user.execute(username);

    result.fold(
          (failure) => emit(LoginFailure(failure.message)),
          (token) {
        user.fold(
              (failure) => emit(LoginFailure(failure.message)),
              (user) => emit(SessionSaving(SessionData(
            token: token.token!,
            userid: user.id,
            expiry: token.expiry!,
            username: user.username,
            email: user.email,
          ))),
        );
      },
    );
  }

  Future<void> savingSession(SessionData session) async {
    final save = await _save.execute(session);
    if (save == LocalDataSource.saveMessage) {
      emit(LoginSuccess());
    }
  }

  Future<void> fetchSession() async {
    emit(LoginInitial());
    final result = await _data.execute();
    result.fold(
          (failure) => emit(LoginFailure(failure.message)),
          (sessionData) {
        if (sessionData != null) {
          emit(LoginSuccessWithData(sessionData));
        } else {
          emit(LoginEnded());
        }
      },
    );
  }

  Future<void> logout(SessionData data) async {
    final result = await _logout.execute(data);
    if (result == LocalDataSource.logoutMessage) {
      emit(LoginEnded());
    }
  }
}

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class Login extends LoginState {}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);

  @override
  List<Object> get props => [message];
}

class SessionSaving extends LoginState {
  final SessionData data;

  SessionSaving(this.data);

  @override
  List<Object> get props => [data];
}

class LoginSuccess extends LoginState {}

class LoginSuccessWithData extends LoginSuccess {
  final SessionData data;

  LoginSuccessWithData(this.data);

  @override
  List<Object> get props => [data];
}

class LoginEnded extends LoginState {}
