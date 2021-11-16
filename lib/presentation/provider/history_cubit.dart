/*
 * Created by andii on 16/11/21 01.03
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 01.03
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/usecases/delete_report.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetReports _query;
  final DeleteReport _delete;

  HistoryCubit(this._query, this._delete) : super(HistoryInitial());

  List<Report> _reports = [];
  List<Report> get reports => _reports;

  Future<void> getHistory(TokenId tokenId) async {
    emit(HistoryLoading());

    final result = await _query.execute(tokenId.token, tokenId.id);
    result.fold(
          (failure) => emit(HistoryError(failure.message)),
          (data) {
        _reports = data;
        return data.isEmpty
            ? emit(HistoryError('Tidak ada data Laporan'))
            : emit(HistoryHasData(data));
      },
    );
  }

  Future<bool> removeReport(TokenId tokenId, String status) async {
    if (status.toLowerCase() == 'belum diproses') {
      final result = await _delete.execute(tokenId.token, tokenId.id);
      emit(HistoryLoading());
      result.fold(
            (failure) => emit(HistoryDeleteSomeData(_reports, failure.message)),
            (success) {
          _reports.removeWhere((element) => element.id == tokenId.id);
          emit(HistoryDeleteSomeData(_reports, success));
        },
      );
      return true;
    }
    return false;
  }
}
