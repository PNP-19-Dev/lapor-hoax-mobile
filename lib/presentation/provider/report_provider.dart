import 'package:flutter/material.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';

class ReportNotifier extends ChangeNotifier {
  Report? _report;

  Report? get report => _report;

  List<Report> _reports = [];

  List<Report> get reports => _reports;

  RequestState _reportState = RequestState.Empty;

  RequestState get reportState => _reportState;

  String _reportMessage = '';

  String get reportMessage => _reportMessage;

  ReportNotifier({required this.getReports, required this.postReport});

  final GetReports getReports;
  final PostReport postReport;

  var token = ''; // anggap aj dlu
  var id = '';

  Future<void> fetchReports() async {
    _reportState = RequestState.Loading;
    notifyListeners();

    final result = await getReports.execute(token, id);

    result.fold((failure) {
      _reportMessage = failure.message;
    }, (reportData) {
      _reports = reportData;
      _reportState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Future<void> sendReport(ReportRequest request) async {
    _reportState = RequestState.Loading;
    notifyListeners();

    final result = await postReport.execute(token, request);
    result.fold((failure) {
      _reportMessage = failure.message;
    }, (reportData) {
      _report = reportData;
      _reportState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
