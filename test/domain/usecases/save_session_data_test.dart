/*
 * Created by andii on 15/11/21 13.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 15/11/21 12.57
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveSessionData usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = SaveSessionData(mockRepository);
  });

  test('should remove feed from saved feed in repository', () async {
    // arrange
    when(mockRepository.saveSessionData(testSessionData))
        .thenAnswer((_) async => 'Anda Login');
    // act
    final result = await usecase.execute(testSessionData);
    // assert
    verify(mockRepository.saveSessionData(testSessionData));
    expect(result, 'Anda Login');
  });
}
