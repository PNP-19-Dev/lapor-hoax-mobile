import 'package:flutter/material.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/token_id.dart';
import 'package:laporhoax/data/model/user_report.dart';
import 'package:laporhoax/util/result_state.dart';

class ReportsProvider extends ChangeNotifier {
  final LaporhoaxApi api;
  final TokenId tokenId;

  ReportsProvider({required this.api, required this.tokenId}) {
    _getReports();
  }

  String _message = '';
  int _count = 0;
  late UserReport _reports;
  late ResultState _state;

  String get message => _message;

  int get count => _count;

  UserReport get reports => _reports;

  ResultState get state => _state;

  Future<dynamic> _getReports() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final reports = await api.getReport(tokenId.token, tokenId.id);

      if (reports.results.isEmpty || reports.count == 0) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        _count = reports.results.length;
        return _reports = reports;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error $e';
    }
  }

  Future<String?> deleteReport(String reportId) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final report = await api.deleteReport(tokenId.token, reportId);

      if (report == 'success') {
        _state = ResultState.HasData;
        _getReports();
        return _message = report;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error $e';
    }
  }
}
