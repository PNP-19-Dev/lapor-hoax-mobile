/*
 * Created by andii on 16/11/21 01.03
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 00.51
 */
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/presentation/provider/profile_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'profile_cubit_test.mocks.dart';

@GenerateMocks([
  GetUser,
])
void main(){
  late MockGetUser _user;
  late ProfileCubit bloc;

  setUp((){
    _user = MockGetUser();
    bloc = ProfileCubit(_user);
  });

  const email = 'email';

  blocTest<ProfileCubit, ProfileState>(
    'Should return success callback when fetch profile data',
    build: () {
      when(_user.execute(email)).thenAnswer((_) async => Right(testUser));
      return bloc;
    },
    act: (bloc) => bloc.getData(email),
    verify: (bloc) => bloc.getData(email),
    expect: () => <ProfileState>[
      ProfileGetData(),
      ProfileDataFetched(testUser),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'Should return error callback when fetch profile data',
    build: () {
      when(_user.execute(email)).thenAnswer((_) async => Left(ServerFailure('Failure')));
      return bloc;
    },
    act: (bloc) => bloc.getData(email),
    verify: (bloc) => bloc.getData(email),
    expect: () => <ProfileState>[
      ProfileGetData(),
      ProfileDataError('Failure'),
    ],
  );
}