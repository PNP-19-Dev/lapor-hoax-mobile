/*
 * Created by andii on 22/11/21 14.56
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 17/11/21 18.50
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_dark_status.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockRepository repository;
  late GetDarkStatus darkStatus;
  setUp(() {
    repository = MockRepository();
    darkStatus = GetDarkStatus(repository);
  });

  test('should return true when dark is Enabled when usecases executed',
      () async {
    // arrange
    when(repository.isDark()).thenAnswer((_) async => true);
    // act
    final result = await darkStatus.execute();
    // assert
    expect(result, true);
  });
}
