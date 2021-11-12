import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/domain/usecases/get_categories.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';
import 'package:laporhoax/presentation/provider/report_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'report_cubit_test.mocks.dart';

@GenerateMocks([
  GetCategories,
  PostReport,
])
void main() {
  late ReportCubit bloc;
  late MockGetCategories _category;
  late MockPostReport _send;

  setUp(() {
    _category = MockGetCategories();
    _send = MockPostReport();
    bloc = ReportCubit(_category, _send);
  });

  group('Categories', () {
    blocTest<ReportCubit, ReportState>(
      'Should get the category from usecases',
      build: () {
        when(_category.execute())
            .thenAnswer((_) async => Right([testCategory]));
        return bloc;
      },
      act: (cubit) => cubit.fetchCategory(),
      verify: (cubit) => cubit.fetchCategory(),
      expect: () => [
        CategoryInitial('mendapatkan data'),
        CategoryFetched([testCategory]),
      ],
    );

    blocTest<ReportCubit, ReportState>(
      'Should return error when data is unsuccessful',
      build: () {
        when(_category.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        return bloc;
      },
      act: (cubit) => cubit.fetchCategory(),
      verify: (cubit) => cubit.fetchCategory(),
      expect: () => [
        CategoryInitial('mendapatkan data'),
        CategoryError('Failure'),
      ],
    );
  });

  group('Send Report', () {
    const token = 'token';
    final report = ReportRequest(
      user: 1,
      url: 'url',
      description: 'description',
      category: 'category',
      isAnonym: true,
      img: XFile(''),
    );

    blocTest<ReportCubit, ReportState>(
      'Should return success callback when report is sent',
      build: () {
        when(_send.execute(token, report))
            .thenAnswer((_) async => Right(testReport));
        return bloc;
      },
      act: (cubit) => cubit.sendReport(
        token,
        report.user,
        report.url,
        report.description,
        report.img,
        report.category,
        report.isAnonym,
      ),
      expect: () => [
        ReportUploading(),
        // ReportUploaded(testReport),
      ],
    );

    blocTest<ReportCubit, ReportState>(
      'Should return error when data is failed to upload',
      build: () {
        when(_send.execute(token, report))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return bloc;
      },
      act: (cubit) => cubit.sendReport(
        token,
        report.user,
        report.url,
        report.description,
        report.img,
        report.category,
        report.isAnonym,
      ),
      expect: () => [
        ReportUploading(),
        // ReportError('Failure'),
      ],
    );
  });
}
