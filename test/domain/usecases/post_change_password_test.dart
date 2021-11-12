/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late PostChangePassword usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = PostChangePassword(mockRepository);
  });

  final tOldPass = 'oldPass';
  final tNewPass = 'newPass';
  final tToken = 'token';

  group('PostChangePassword Test', () {
    group('execute', () {
      test("should get 'success' callback when execute function is called",
              () async {
            // arrange
            when(mockRepository.postChangePassword(tOldPass, tNewPass, tToken))
                .thenAnswer((_) async => Right('success'));
            // act
            final result = await usecase.execute(tOldPass, tNewPass, tToken);
            // assert
            expect(result, Right('success'));
          });
    });
  });
}
