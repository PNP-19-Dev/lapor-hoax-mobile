/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.57
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_session_status.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetSessionStatus usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetSessionStatus(mockRepository);
  });

  test('should get session status from repository', () async {
    // arrange
    when(mockRepository.isSessionActivated()).thenAnswer((_) async => true);
    // act
    final result = await usecase.execute();
    // assert
    expect(result, true);
  });
}
