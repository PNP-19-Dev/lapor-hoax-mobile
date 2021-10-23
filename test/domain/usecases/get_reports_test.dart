import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetReports usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetReports(mockRepository);
  });

//  final tQuestions = <Question>[];
  final tToken = 'token';
  final tId = 1;

  group('GetReports Test', () {
    group('execute', () {
      test("should get list of user's report when execute function is called",
          () async {
        // arrange
        when(mockRepository.getReports(tToken, tId))
            .thenAnswer((_) async => Right(testReportList));
        // act
        final result = await usecase.execute(tToken, tId);
        // assert
        expect(result, Right(testReportList));
      });
    });
  });
}
