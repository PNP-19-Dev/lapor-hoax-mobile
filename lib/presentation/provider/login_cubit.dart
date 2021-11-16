/*
 * Created by andii on 17/11/21 00.28
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 22.57
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/set_session.dart';

class LoginCubit extends Cubit<LoginState> {
  final PostLogin _login;
  final GetUser _user;
  final GetSessionData _data;
  final SetSession _setSession;

  LoginCubit(
    this._login,
    this._user,
    this._data,
    this._setSession,
  ) : super(LoginInitial());

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
          (user) {
            _setSession.execute(data: SessionData(
              username: user.username,
              token: token.token!,
              expiry: token.expiry!,
              email: user.email,
              userid: user.id,
            ));
            emit(LoginSuccess());
          },
        );
      },
    );
  }

  Future<void> fetchSession() async {
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

  Future<void> logout() async {
    final result = await _setSession.execute();
    if (!result){
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

class LoginSuccess extends LoginState {}

class LoginSuccessWithData extends LoginSuccess {
  final SessionData data;

  LoginSuccessWithData(this.data);

  @override
  List<Object> get props => [data];
}

class LoginEnded extends LoginState {}
