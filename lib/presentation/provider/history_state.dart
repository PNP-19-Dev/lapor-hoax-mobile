/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.52
 */

part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}

class HistoryHasData extends HistoryState {
  final List<Report> reports;

  const HistoryHasData(this.reports);

  @override
  List<Object> get props => [reports];
}

class HistoryDeleteSomeData extends HistoryHasData {
  final List<Report> reports;
  final String message;

  const HistoryDeleteSomeData(this.reports, this.message) : super(reports);

  @override
  List<Object> get props => [reports];
}
