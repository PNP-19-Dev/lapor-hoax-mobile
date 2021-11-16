/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.57
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetUser usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetUser(mockRepository);
  });

  final tEmail = 'email';

  group('GetUser Test', () {
    group('execute', () {
      test('should get user data when execute function is called', () async {
        // arrange
        when(mockRepository.getUser(tEmail))
            .thenAnswer((_) async => Right(testUser));
        // act
        final result = await usecase.execute(tEmail);
        // assert
        expect(result, Right(testUser));
      });
    });
  });
}
