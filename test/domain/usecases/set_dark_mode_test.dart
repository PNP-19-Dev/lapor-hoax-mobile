/*
 * Created by andii on 22/11/21 14.56
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 17/11/21 18.46
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/set_dark_mode.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockRepository repository;
  late SetDarkMode darkMode;

  setUp(() {
    repository = MockRepository();
    darkMode = SetDarkMode(repository);
  });

  test('should return true when usecases passess true', () async {
    // arrange
    when(repository.setDark(true)).thenAnswer((_) async => true);
    // act
    final result = await darkMode.execute(true);
    // assert
    expect(result, true);
  });
}
