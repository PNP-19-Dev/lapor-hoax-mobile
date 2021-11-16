/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.56
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_feed_detail.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetFeedDetail usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetFeedDetail(mockRepository);
  });

  final tId = 1;

  group('GetFeedDetail Test', () {
    group('execute', () {
      test('should get feed detail from the repository', () async {
        // arrange
        when(mockRepository.getFeedDetail(tId))
            .thenAnswer((_) async => Right(testFeed));
        // act
        final result = await usecase.execute(tId);
        // assert
        expect(result, Right(testFeed));
      });
    });
  });
}
