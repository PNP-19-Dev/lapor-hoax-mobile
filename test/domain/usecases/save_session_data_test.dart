/*
 * Created by andii on 15/11/21 12.51
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 15/11/21 12.12
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
    when(mockRepository.saveSessionData(
      email: testSessionData.email,
      expiry: testSessionData.expiry,
      token: testSessionData.expiry,
      username: testSessionData.username,
      id: testSessionData.userid,
    )).thenAnswer((_) async => 'Anda Login');
    // act
    final result = await usecase.execute(
      email: testSessionData.email,
      expiry: testSessionData.expiry,
      token: testSessionData.expiry,
      username: testSessionData.username,
      id: testSessionData.userid,
    );
    // assert
    verify(mockRepository.saveSessionData(
      email: testSessionData.email,
      expiry: testSessionData.expiry,
      token: testSessionData.expiry,
      username: testSessionData.username,
      id: testSessionData.userid,
    ));
    expect(result, 'Anda Login');
  });
}
