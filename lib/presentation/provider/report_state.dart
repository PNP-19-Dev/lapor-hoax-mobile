/*
 * Created by andii on 14/11/21 14.07
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 11.12
 */

part of 'report_cubit.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLogin extends ReportState {
  final SessionData data;

  ReportLogin(this.data);

  @override
  List<Object> get props => [data];
}

class ReportNotLogin extends ReportState {}

class CategoryInitial extends ReportState {
  final String message;

  CategoryInitial(this.message);

  @override
  List<Object> get props => [message];
}

class CategoryError extends ReportState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class CategoryFetched extends ReportState {
  final List<Category> category;

  CategoryFetched(this.category);

  @override
  List<Object> get props => [category];
}

class ImageFetched extends ReportState {
  final XFile file;

  ImageFetched(this.file);

  @override
  List<Object> get props => [file];
}

class ImageError extends ReportState {
  final String message;

  ImageError(this.message);

  @override
  List<Object> get props => [message];
}

class ReportUploading extends ReportState {}

class ReportError extends ReportState {
  final String message;

  ReportError(this.message);

  @override
  List<Object> get props => [message];
}

class ReportUploaded extends ReportState {
  final Report report;

  ReportUploaded(this.report);

  @override
  List<Object> get props => [report];
}
