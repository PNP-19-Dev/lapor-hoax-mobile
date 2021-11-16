/*
 * Created by andii on 16/11/21 01.03
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 00.44
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/presentation/provider/account_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'account_cubit_test.mocks.dart';

@GenerateMocks([
  GetSessionData,
])
void main() {
  late MockGetSessionData _data;
  late AccountCubit bloc;
  setUp(() {
    _data = MockGetSessionData();
    bloc = AccountCubit(_data);
  });
  group('fetch session', () {
    blocTest<AccountCubit, AccountState>(
      'Should return success callback when fetch session data',
      build: () {
        when(_data.execute()).thenAnswer((_) async => Right(testSessionData));
        return bloc;
      },
      act: (bloc) => bloc.fetchSession(),
      verify: (bloc) => bloc.fetchSession(),
      expect: () => <AccountState>[
        AccountLogin(testSessionData),
      ],
    );

    blocTest<AccountCubit, AccountState>(
      'Should return error callback when login is unsuccessful',
      build: () {
        when(_data.execute()).thenAnswer((_) async => Right(null));
        return bloc;
      },
      act: (bloc) => bloc.fetchSession(),
      verify: (bloc) => bloc.fetchSession(),
      expect: () => <AccountState>[
        AccountNotLogin(),
      ],
    );

    blocTest<AccountCubit, AccountState>(
      'Should return error callback when session failure',
      build: () {
        when(_data.execute())
            .thenAnswer((_) async => Left(CustomException('No Data')));
        return bloc;
      },
      act: (bloc) => bloc.fetchSession(),
      verify: (bloc) => bloc.fetchSession(),
      expect: () => <AccountState>[
        AccountNotLogin(),
      ],
    );
  });
}
