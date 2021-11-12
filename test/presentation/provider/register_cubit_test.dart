/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.00
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/register.dart';
import 'package:laporhoax/domain/usecases/post_fcm_token.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';
import 'package:laporhoax/presentation/provider/register_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'register_cubit_test.mocks.dart';

@GenerateMocks([
  PostRegister,
  PostFCMToken,
])
void main() {
  late RegisterCubit bloc;
  late MockPostRegister _register;
  late MockPostFCMToken _token;

  setUp(() {
    _register = MockPostRegister();
    _token = MockPostFCMToken();
    bloc = RegisterCubit(_register, _token);
  });

  final fcmToken = 'token';
  final user = Register(
    name: 'name',
    email: 'email',
    password: 'password',
  );

  blocTest<RegisterCubit, RegisterState>(
    'should get success callback from server when post data',
    build: () {
      when(_register.execute(user))
          .thenAnswer((_) async => Right(testRegisterData));
      when(_token.execute(testRegisterData.user.id, fcmToken))
          .thenAnswer((_) async => Right('Success'));
      return bloc;
    },
    act: (cubit) => cubit.register(user),
    verify: (cubit) => cubit.register(user),
    expect: () => [
      Registering(),
      RegisterSuccess(testRegisterData.user.id),
    ],
  );
  blocTest<RegisterCubit, RegisterState>(
    'should get error callback from server when post data',
    build: () {
      when(_register.execute(user))
          .thenAnswer((_) async => Left(ServerFailure('Failure')));
      return bloc;
    },
    act: (cubit) => cubit.register(user),
    verify: (cubit) => cubit.register(user),
    expect: () => [
      Registering(),
      RegisterError('Failure'),
    ],
  );
}
