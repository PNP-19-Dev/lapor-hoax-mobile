import 'package:core/data/models/report_request.dart';
import 'package:core/data/models/token_id.dart';
import 'package:core/domain/entities/report.dart';
import 'package:core/domain/usecases/delete_report.dart';
import 'package:core/domain/usecases/get_categories.dart';
import 'package:core/domain/usecases/get_reports.dart';
import 'package:core/domain/usecases/post_report.dart';
import 'package:core/presentation/provider/report_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
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
  final tReportRequest = ReportRequest(
    user: 1,
    url: "url",
    category: "category",
    isAnonym: false,
    description: "description",
    img: XFile('null'),
  );
  final tReport = Report(
    id: 1,
    url: "url",
    img: "img",
    category: "category",
    status: "status",
    isAnonym: false,
    dateReported: "dateReported",
    description: "description",
    prosesDate: "prosesDate",
    verdict: "verdict",
    verdictDesc: "verdictDesc",
    verdictDate: "verdictDate",
    user: 1,
    verdictJudge: 1,
  );

  test('should change report data when data is gotten successfully', () async {
    // arrange
    when(mockGetReports.execute(tToken, tId))
        .thenAnswer((_) async => Right([testReport]));
    // act
    await provider.fetchReports(TokenId(tId, tToken));
    // assert
    expect(provider.fetchReportState, RequestState.loaded);
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
    expect(provider.fetchReportState, RequestState.error);
    expect(provider.fetchReportMessage, "Can't get data");
    expect(listenerCallCount, 2);
  });

  test('should change category data when data is gotten successfully',
      () async {
    // arrange
    when(mockGetCategories.execute())
        .thenAnswer((_) async => Right([testCategory]));
    // act
    await provider.fetchCategories();
    // assert
    expect(provider.fetchCategoryState, RequestState.loaded);
    expect(provider.category, [testCategory]);
    expect(listenerCallCount, 2);
  });

  test('should return error when fetch category data is unsuccessful',
      () async {
    // arrange
    when(mockGetCategories.execute())
        .thenAnswer((_) async => Left(ServerFailure("")));
    // act
    await provider.fetchCategories();
    // assert
    expect(provider.fetchCategoryState, RequestState.error);
    expect(provider.fetchReportMessage, "");
    expect(listenerCallCount, 2);
  });

  test('should return callback when data sent successfully', () async {
    // arrange
    when(mockPostReport.execute(
      tToken,
      tReportRequest,
    )).thenAnswer((_) async => Right(tReport));
    // act
    await provider.sendReport(tToken, tReportRequest);
    // assert
    expect(provider.postReportState, RequestState.success);
    expect(provider.report, tReport);
    expect(listenerCallCount, 2);
  });

  test('should return error when sending is unsuccessful', () async {
    // arrange
    when(mockPostReport.execute(tToken, tReportRequest))
        .thenAnswer((_) async => Left(ServerFailure("")));
    // act
    await provider.sendReport(tToken, tReportRequest);
    // assert
    expect(provider.postReportState, RequestState.error);
    expect(provider.fetchReportMessage, "");
    expect(listenerCallCount, 2);
  });

  test('should return callback when data remove sent successfully', () async {
    // arrange
    when(mockDeleteReport.execute(
      tToken,
      tId,
    )).thenAnswer((_) async => Right('Success'));
    // act
    await provider.removeReport(tToken, tId, 'belum diproses');
    // assert
    expect(provider.deleteReportState, RequestState.success);
    expect(provider.deleteReportMessage, 'Laporan Telah Dihapus');
    expect(listenerCallCount, 2);
  });

  test('should return error when sending remove is unsuccessful', () async {
    // arrange
    when(mockDeleteReport.execute(tToken, tId))
        .thenAnswer((_) async => Left(ServerFailure("")));
    // act
    await provider.removeReport(tToken, tId, 'belum diproses');
    // assert
    expect(provider.deleteReportState, RequestState.error);
    expect(provider.deleteReportMessage, "");
    expect(listenerCallCount, 2);
  });
}
