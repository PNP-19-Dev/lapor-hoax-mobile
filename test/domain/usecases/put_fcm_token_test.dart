/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.57
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/put_fcm_token.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late PutFCMToken usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = PutFCMToken(mockRepository);
  });

  final tUser = 1;
  final tToken = 'newPass';

  group('PutFCMToken Test', () {
    group('execute', () {
      test("should get 'success' callback when execute function is called",
              () async {
            // arrange
            when(mockRepository.putFCMToken(tUser, tToken))
                .thenAnswer((_) async => Right('success'));
            // act
            final result = await usecase.execute(tUser, tToken);
            // assert
            expect(result, Right('success'));
          });
    });
  });
}
