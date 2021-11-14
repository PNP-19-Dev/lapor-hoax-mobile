/*
 * Created by andii on 14/11/21 14.07
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 12.38
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUser _user;

  ProfileCubit(this._user) : super(ProfileInitial());

  Future<void> getData(String email) async {
    emit(ProfileGetData());
    final result = await _user.execute(email);
    result.fold(
      (failure) => emit(ProfileDataError(failure.message)),
      (data) => emit(ProfileDataFetched(data)),
    );
  }
}

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileGetData extends ProfileState {}

class ProfileDataError extends ProfileState {
  final String message;

  ProfileDataError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileDataFetched extends ProfileState {
  final User user;

  ProfileDataFetched(this.user);

  @override
  List<Object> get props => [];
}
