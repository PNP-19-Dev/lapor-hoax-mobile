import 'package:flutter/material.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/usecases/delete_report.dart';
import 'package:laporhoax/domain/usecases/get_categories.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';
import 'package:laporhoax/utils/state_enum.dart';

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

  ReportNotifier({
    required this.getReports,
    required this.postReport,
    required this.deleteReport,
    required this.getCategories,
  });

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
      if (reportData.isEmpty) {
        _fetchReportState = RequestState.Empty;
        _fetchReportMessage = "Tidak ada data laporan saat ini";
        notifyListeners();
      } else {
        _fetchReportState = RequestState.Loaded;
        _reports = reportData;
        notifyListeners();
      }
    });
  }

  Future<List<Category>> fetchCategories() async {
    _fetchCategoryState = RequestState.Loading;
    notifyListeners();

    final result = await getCategories.execute();

    result.fold((failure) {
      _fetchCategoryState = RequestState.Error;
      _fetchCategoryMessage = failure.message;
      notifyListeners();
    }, (categoryData) {
      _fetchCategoryState = RequestState.Loaded;
      _category = categoryData;
      notifyListeners();
    });

    return _category;
  }

  Future<void> sendReport(String token, ReportRequest request) async {
    _postReportState = RequestState.Loading;
    notifyListeners();

    final result = await postReport.execute(token, request);
    result.fold((failure) {
      _postReportState = RequestState.Error;
      _postReportMessage = 'error: ${failure.message}';
      notifyListeners();
    }, (reportData) {
      _postReportState = RequestState.Success;
      _report = reportData;
      _postReportMessage = 'Data Berhasil Diupload';
      notifyListeners();
    });
  }

  Future<bool> removeReport(String token, int id, String status) async {
    _deleteReportState = RequestState.Loading;
    notifyListeners();

    if (status.toLowerCase() != 'belum diproses') {
      return false;
    }

    final result = await deleteReport.execute(token, id);
    result.fold((failure) {
      _deleteReportMessage = failure.message;
      _deleteReportState = RequestState.Error;
      notifyListeners();
    }, (reportData) {
      _deleteReportMessage = reportRemoveSuccess;
      _deleteReportState = RequestState.Success;
      notifyListeners();
    });
    return true;
  }
}
