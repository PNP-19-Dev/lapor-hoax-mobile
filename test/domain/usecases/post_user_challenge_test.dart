/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late PostUserChallenge usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = PostUserChallenge(mockRepository);
  });

  group('PostUserChallenge Test', () {
    group('execute', () {
      test("should get 'success' callback when execute function is called",
              () async {
            // arrange
            when(mockRepository.postUserChallenge(testUserChallenge))
                .thenAnswer((_) async => Right('success'));
            // act
            final result = await usecase.execute(testUserChallenge);
            // assert
            expect(result, Right('success'));
          });
    });
  });
}
