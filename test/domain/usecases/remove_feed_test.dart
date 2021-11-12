/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.57
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/remove_feed.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveFeed usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = RemoveFeed(mockRepository);
  });

  test('should remove feed from saved feed in repository', () async {
    // arrange
    when(mockRepository.removeFeed(testFeed))
        .thenAnswer((_) async => Right('Berita Telah Dihapus'));
    // act
    final result = await usecase.execute(testFeed);
    // assert
    verify(mockRepository.removeFeed(testFeed));
    expect(result, Right('Berita Telah Dihapus'));
  });
}
