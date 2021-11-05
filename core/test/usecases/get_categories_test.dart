import 'package:core/domain/entities/category.dart';
import 'package:core/domain/usecases/get_categories.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';

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
