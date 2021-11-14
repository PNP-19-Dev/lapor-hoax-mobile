/*
 * Created by andii on 14/11/21 14.07
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 11.16
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';

class AccountCubit extends Cubit<AccountState> {
  final GetSessionData _data;

  AccountCubit(this._data) : super(AccountInitial());

  Future<void> fetchSession() async {
    final result = await _data.execute();
    result.fold(
          (failure) => emit(AccountNotLogin()),
          (sessionData) {
        if (sessionData != null) {
          emit(AccountLogin(sessionData));
        } else {
          emit(AccountNotLogin());
        }
      },
    );
  }
}

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountNotLogin extends AccountState {}

class AccountFailure extends AccountState {
  final String message;

  AccountFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AccountLogin extends AccountState {
  final SessionData data;

  AccountLogin(this.data);

  @override
  List<Object> get props => [data];
}
