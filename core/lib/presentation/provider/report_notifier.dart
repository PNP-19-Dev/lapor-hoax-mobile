import 'package:flutter/material.dart';

import '../../data/models/report_request.dart';
import '../../data/models/token_id.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/report.dart';
import '../../domain/usecases/delete_report.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_reports.dart';
import '../../domain/usecases/post_report.dart';
import '../../utils/state_enum.dart';

class ReportNotifier extends ChangeNotifier {
  static const reportRemoveSuccess = 'Laporan Telah Dihapus';
  static const reportFailure = 'Ups Ada Masalah';

  List<Category> _category = [];
  List<Category> get category => _category;

  Report? _report;
  Report? get report => _report;

  TokenId? _tokenId;
  TokenId? get tokenId => _tokenId;

  List<Report> _reports = [];
  List<Report> get reports => _reports;

  RequestState _fetchReportState = RequestState.empty;
  RequestState get fetchReportState => _fetchReportState;

  RequestState _postReportState = RequestState.empty;
  RequestState get postReportState => _postReportState;

  RequestState _fetchCategoryState = RequestState.empty;
  RequestState get fetchCategoryState => _fetchCategoryState;

  RequestState _deleteReportState = RequestState.empty;
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
    _tokenId = tokenId;
    _fetchReportState = RequestState.loading;
    notifyListeners();

    final result = await getReports.execute(tokenId.token, tokenId.id);

    result.fold((failure) {
      _fetchReportState = RequestState.error;
      _fetchReportMessage = failure.message;
      notifyListeners();
    }, (reportData) {
      _fetchReportState = RequestState.loaded;
      _reports = reportData;
      notifyListeners();

      if (_reports.isEmpty) {
        _fetchReportState = RequestState.empty;
        _fetchReportMessage = "Tidak ada data saat ini";
        notifyListeners();
      }
    });
  }

  Future<List<Category>> fetchCategories() async {
    _fetchCategoryState = RequestState.loading;
    notifyListeners();

    final result = await getCategories.execute();

    result.fold((failure) {
      _fetchCategoryState = RequestState.error;
      _fetchCategoryMessage = failure.message;
      notifyListeners();
    }, (categoryData) {
      _fetchCategoryState = RequestState.loaded;
      _category = categoryData;
      notifyListeners();
    });

    return _category;
  }

  Future<void> sendReport(String token, ReportRequest request) async {
    _postReportState = RequestState.loading;
    notifyListeners();

    final result = await postReport.execute(token, request);
    result.fold((failure) {
      _postReportState = RequestState.error;
      _postReportMessage = 'error: ${failure.message}';
      notifyListeners();
    }, (reportData) {
      _postReportState = RequestState.success;
      _report = reportData;
      _postReportMessage = 'Data Berhasil Diupload';
      notifyListeners();
    });
  }

  Future<bool> removeReport(String token, int id, String status) async {
    _deleteReportState = RequestState.loading;
    notifyListeners();

    if (status.toLowerCase() != 'belum diproses'){
      return false;
    }

    final result = await deleteReport.execute(token, id);
    result.fold((failure) {
      _deleteReportMessage = failure.message;
      _deleteReportState = RequestState.error;
      notifyListeners();
    }, (reportData) {
      _deleteReportMessage = reportRemoveSuccess;
      _deleteReportState = RequestState.success;
      notifyListeners();
    });
    return true;
  }
}
