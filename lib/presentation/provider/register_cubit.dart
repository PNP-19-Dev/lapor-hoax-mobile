/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.51
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/register.dart';
import 'package:laporhoax/domain/usecases/post_fcm_token.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final PostRegister _register;
  final PostFCMToken _token;

  RegisterCubit(this._register, this._token) : super(RegisterInitial());

  Future<void> register(Register user) async {
    emit(Registering());

    final result = await _register.execute(user);

    result.fold(
      (failure) => emit(RegisterError(failure.message)),
      (data) async {
        final token = await _token.execute(data.user.id, data.token);
        token.fold(
          (failure) => emit(RegisterError(failure.message)),
          (success) => emit(RegisterSuccess(data.user.id)),
        );
      },
    );
  }
}
