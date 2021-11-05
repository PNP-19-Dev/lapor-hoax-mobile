import 'package:dartz/dartz.dart';

import '../../data/models/report_request.dart';
import '../../utils/failure.dart';
import '../entities/report.dart';
import '../repositories/repository.dart';

class PostReport {
  final Repository repository;

  PostReport(this.repository);

  Future<Either<Failure, Report>> execute(String token, ReportRequest report) {
    return repository.postReport(token, report);
  }
}
