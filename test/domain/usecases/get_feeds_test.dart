/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetFeeds usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetFeeds(mockRepository);
  });

  group('GetFeeds Test', () {
    group('execute', () {
      test('should get list of feeds when execute function is called',
              () async {
            // arrange
            when(mockRepository.getFeeds())
                .thenAnswer((_) async => Right(testFeedList));
            // act
            final result = await usecase.execute();
            // assert
            expect(result, Right(testFeedList));
          });
    });
  });
}
