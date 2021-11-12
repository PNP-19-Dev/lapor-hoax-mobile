/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.51
 */

part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class Registering extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterSuccess extends RegisterState {
  final int id;

  RegisterSuccess(this.id);

  @override
  List<Object> get props => [id];
}
