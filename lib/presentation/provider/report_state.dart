part of 'report_cubit.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

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
