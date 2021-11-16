/*
 * Created by andii on 17/11/21 00.28
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 17/11/21 00.22
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/provider/dark_provider.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockPreferencesHelper helper;
  late DarkProvider provider;
  late int listenerCallCount;

  setUp(() async {
    listenerCallCount = 0;
    helper = MockPreferencesHelper();

    when(helper.isDark).thenAnswer((_) async => true);

    provider = DarkProvider(helper)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  test('should return dark theme when dark theme is activated', () async {
    // arrange
    when(helper.isDark).thenAnswer((_) async => true);
    // act
    provider.enableDarkTheme(true);
    // assert
    verify(helper.setDark(true));
    expect(provider.isDarkTheme, true);
    expect(listenerCallCount, 1);
  });
}
