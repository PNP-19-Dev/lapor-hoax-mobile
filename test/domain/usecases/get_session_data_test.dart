/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.57
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetSessionData usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetSessionData(mockRepository);
  });

  group('GetSessionData Test', () {
    group('execute', () {
      test('should get session data when execute function is called', () async {
        // arrange
        when(mockRepository.getSessionData())
            .thenAnswer((_) async => Right(testSessionData));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(testSessionData));
      });
    });
  });
}
