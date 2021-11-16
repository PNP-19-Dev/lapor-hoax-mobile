/*
 * Created by andii on 17/11/21 00.28
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 23.33
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/set_session.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockRepository repository;
  late SetSession session;

  setUp(() {
    repository = MockRepository();
    session = SetSession(repository);
  });

  group('Set Session', () {
    test('should return TRUE when SAVING session', () async {
      // arrange
      when(repository.setSession(data: testSessionData))
          .thenAnswer((_) async => true);
      // act
      final result = await session.execute(data: testSessionData);
      // assert
      expect(result, true);
    });
    test('should return FALSE when REMOVING session', () async {
      // arrange
      when(repository.setSession())
          .thenAnswer((_) async => false);
      // act
      final result = await session.execute();
      // assert
      expect(result, false);
    });
  });
}
