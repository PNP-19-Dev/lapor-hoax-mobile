import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/usecases/delete_report.dart';
import 'package:laporhoax/domain/usecases/get_categories.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';
import 'package:laporhoax/presentation/provider/report_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'report_notifier_test.mocks.dart';

@GenerateMocks([
  GetReports,
  PostReport,
  DeleteReport,
  GetCategories,
])
void main() {
  late ReportNotifier provider;
  late MockGetReports mockGetReports;
  late MockPostReport mockPostReport;
  late MockDeleteReport mockDeleteReport;
  late MockGetCategories mockGetCategories;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetReports = MockGetReports();
    mockPostReport = MockPostReport();
    mockDeleteReport = MockDeleteReport();
    mockGetCategories = MockGetCategories();
    provider = ReportNotifier(
      getReports: mockGetReports,
      postReport: mockPostReport,
      deleteReport: mockDeleteReport,
      getCategories: mockGetCategories,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tToken = 'token';
  final tId = 1;

  test('should change report data when data is gotten successfully', () async {
    // arrange
    when(mockGetReports.execute(tToken, tId))
        .thenAnswer((_) async => Right([testReport]));
    // act
    await provider.fetchReports(TokenId(tId, tToken));
    // assert
    expect(provider.fetchReportState, RequestState.Loaded);
    expect(provider.reports, [testReport]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetReports.execute(tToken, tId))
        .thenAnswer((_) async => Left(ServerFailure("Can't get data")));
    // act
    await provider.fetchReports(TokenId(tId, tToken));
    // assert
    expect(provider.fetchReportState, RequestState.Error);
    expect(provider.fetchReportMessage, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
