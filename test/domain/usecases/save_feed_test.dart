/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.58
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveFeed usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = SaveFeed(mockRepository);
  });

  test('should remove feed from saved feed in repository', () async {
    // arrange
    when(mockRepository.saveFeed(testFeed))
        .thenAnswer((_) async => Right('Berita Telah Disimpan'));
    // act
    final result = await usecase.execute(testFeed);
    // assert
    verify(mockRepository.saveFeed(testFeed));
    expect(result, Right('Berita Telah Disimpan'));
  });
}
