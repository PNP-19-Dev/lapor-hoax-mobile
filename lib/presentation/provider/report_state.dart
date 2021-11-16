/*
 * Created by andii on 16/11/21 09.46
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 08.48
 */

part of 'report_cubit.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class CategoryInitial extends ReportState {
  final String message;

  const CategoryInitial(this.message);

  @override
  List<Object> get props => [message];
}

class CategoryError extends ReportState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class CategoryFetched extends ReportState {
  final List<Category> category;

  const CategoryFetched(this.category);

  @override
  List<Object> get props => [category];
}

class ReportUploading extends ReportState {}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object> get props => [message];
}

class ReportUploaded extends ReportState {
  final Report report;

  const ReportUploaded(this.report);

  @override
  List<Object> get props => [report];
}
