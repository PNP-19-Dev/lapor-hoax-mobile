import 'package:flutter/material.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/usecases/delete_report.dart';
import 'package:laporhoax/domain/usecases/get_categories.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';

class ReportNotifier extends ChangeNotifier {
  static const reportRemoveSuccess = 'Laporan Telah Dihapus';
  static const reportFailure = 'Ups Ada Masalah';

  List<Category> _category = [];

  List<Category> get category => _category;

  Report? _report;

  Report? get report => _report;

  List<Report> _reports = [];

  List<Report> get reports => _reports;

  RequestState _fetchReportState = RequestState.Empty;

  RequestState get fetchReportState => _fetchReportState;

  RequestState _postReportState = RequestState.Empty;

  RequestState get postReportState => _postReportState;

  RequestState _fetchCategoryState = RequestState.Empty;

  RequestState get fetchCategoryState => _fetchCategoryState;

  RequestState _deleteReportState = RequestState.Empty;

  RequestState get deleteReportState => _deleteReportState;

  String _fetchReportMessage = '';

  String get fetchReportMessage => _fetchReportMessage;

  String _fetchCategoryMessage = '';

  String get fetchCategoryMessage => _fetchCategoryMessage;

  String _postReportMessage = '';

  String get postReportMessage => _postReportMessage;

  String _deleteReportMessage = '';

  String get deleteReportMessage => _deleteReportMessage;

  ReportNotifier(
      {required this.getReports,
      required this.postReport,
      required this.deleteReport,
      required this.getCategories});

  final GetReports getReports;
  final PostReport postReport;
  final DeleteReport deleteReport;
  final GetCategories getCategories;

  Future<void> fetchReports(TokenId tokenId) async {
    _fetchReportState = RequestState.Loading;
    notifyListeners();

    final result = await getReports.execute(tokenId.token, tokenId.id);

    result.fold((failure) {
      _fetchReportState = RequestState.Error;
      _fetchReportMessage = failure.message;
      notifyListeners();
    }, (reportData) {
      _reports = reportData;
      _fetchReportState = RequestState.Loaded;
      notifyListeners();

      if (_reports.length == 0) {
        _fetchReportMessage = "Tidak ada data saat ini";
        _fetchReportState = RequestState.Empty;
        notifyListeners();
      }
    });
  }

  Future<void> fetchCategories() async {
    _fetchCategoryState = RequestState.Loading;
    notifyListeners();

    final result = await getCategories.execute();

    result.fold((failure) {
      _fetchCategoryMessage = failure.message;
    }, (categoryData) {
      _category = categoryData;
      _fetchCategoryState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Future<void> sendReport(String token, ReportRequest request) async {
    _postReportState = RequestState.Loading;
    notifyListeners();

    final result = await postReport.execute(token, request);
    result.fold((failure) {
      _postReportMessage = 'error: ${failure.message}';
      _postReportState = RequestState.Error;
      notifyListeners();
    }, (reportData) {
      _report = reportData;
      _postReportMessage = 'Data Berhasil Diupload';
      _postReportState = RequestState.Success;
      notifyListeners();
    });
  }

  Future<void> removeReport(TokenId tokenId, Report report) async {
    _deleteReportState = RequestState.Loading;
    notifyListeners();

    final result = await deleteReport.execute(tokenId.token, report);
    result.fold((failure) {
      _deleteReportMessage = failure.message;
    }, (reportData) {
      _deleteReportMessage = reportData;
      _postReportState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
