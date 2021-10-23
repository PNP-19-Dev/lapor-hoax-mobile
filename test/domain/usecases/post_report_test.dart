import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late PostReport usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = PostReport(mockRepository);
  });

  final tToken = 'token';
  final reportRequestTest = ReportRequest(
    user: 1,
    url: "url",
    category: "category",
    isAnonym: false,
    description: "description",
    img: XFile('null'),
  );

  group('PostReport Test', () {
    group('execute', () {
      test("should get report callback when execute function is called",
          () async {
        // arrange
        when(mockRepository.postReport(tToken, reportRequestTest))
            .thenAnswer((_) async => Right(testReport));
        // act
        final result = await usecase.execute(tToken, reportRequestTest);
        // assert
        expect(result, Right(testReport));
      });
    });
  });
}
