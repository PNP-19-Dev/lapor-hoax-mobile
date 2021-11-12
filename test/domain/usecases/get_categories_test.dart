/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/domain/usecases/get_categories.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetCategories usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetCategories(mockRepository);
  });

  final tCategories = <Category>[];

  group('GetCategoires Test', () {
    group('execute', () {
      test('should get list of categories when execute function is called',
              () async {
            // arrange
            when(mockRepository.getCategories())
                .thenAnswer((_) async => Right(tCategories));
            // act
            final result = await usecase.execute();
            // assert
            expect(result, Right(tCategories));
          });
    });
  });
}
