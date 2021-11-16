/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.55
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/usecases/get_password_reset.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';

class PasswordCubit extends Cubit<PasswordState> {
  final PostChangePassword _change;
  final GetPasswordReset _reset;
  final GetUser _user;

  PasswordCubit(this._change, this._reset, this._user)
      : super(PasswordInitial());

  Future<void> getUserData(String email) async {
    emit(PasswordLoading());
    final result = await _user.execute(email);
    result.fold(
          (failure) => emit(PasswordError(failure.message)),
          (data) => emit(UserHasData(data)),
    );
  }

  Future<void> changePassword(String oldPass, String newPass, String token) async {
    emit(PasswordLoading());
    final result = await _change.execute(oldPass, newPass, token);

    result.fold(
          (failure) => emit(PasswordError(failure.message)),
          (success) => emit(PasswordReseted()),
    );
  }

  Future<void> resetPassword(String email) async {
    emit(PasswordLoading());
    final result = await _reset.execute(email);

    result.fold(
          (failure) => emit(PasswordError(failure.message)),
          (success) => emit(PasswordReseted()),
    );
  }
}

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object?> get props => [];
}

class PasswordInitial extends PasswordState {}

class PasswordLoading extends PasswordState {}

class PasswordError extends PasswordState {
  final String message;

  PasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserHasData extends PasswordState {
  final User data;

  UserHasData(this.data);

  @override
  List<Object?> get props => [data];
}

class PasswordChanged extends PasswordState {}

class PasswordReseted extends PasswordState {}
