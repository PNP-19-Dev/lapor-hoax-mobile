import 'package:flutter/material.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/usecases/delete_report.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';

class ReportNotifier extends ChangeNotifier {
  Report? _report;

  Report? get report => _report;

  List<Report> _reports = [];

  List<Report> get reports => _reports;

  RequestState _fetchReportState = RequestState.Empty;

  RequestState get fetchReportState => _fetchReportState;

  RequestState _postReportState = RequestState.Empty;

  RequestState get postReportState => _postReportState;

  RequestState _deleteReportState = RequestState.Empty;

  RequestState get deleteReportState => _deleteReportState;

  String _fetchReportMessage = '';

  String get fetchReportMessage => _fetchReportMessage;

  String _postReportMessage = '';

  String get postReportMessage => _postReportMessage;

  String _deleteReportMessage = '';

  String get deleteReportMessage => _deleteReportMessage;

  ReportNotifier(
      {required this.getReports,
      required this.postReport,
      required this.deleteReport});

  final GetReports getReports;
  final PostReport postReport;
  final DeleteReport deleteReport;

  var token = ''; // anggap aj dlu
  var id = '';

  Future<void> fetchReports() async {
    _fetchReportState = RequestState.Loading;
    notifyListeners();

    final result = await getReports.execute(token, id);

    result.fold((failure) {
      _fetchReportMessage = failure.message;
    }, (reportData) {
      _reports = reportData;
      _fetchReportState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Future<void> sendReport(ReportRequest request) async {
    _postReportState = RequestState.Loading;
    notifyListeners();

    final result = await postReport.execute(token, request);
    result.fold((failure) {
      _postReportMessage = failure.message;
    }, (reportData) {
      _report = reportData;
      _postReportState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Future<void> removeReport(Report report) async {
    _deleteReportState = RequestState.Loading;
    notifyListeners();

    final result = await deleteReport.execute(token, report);
    result.fold((failure) {
      _deleteReportMessage = failure.message;
    }, (reportData) {
      _deleteReportMessage = reportData;
      _postReportState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
