import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class PostReport {
  final Repository repository;

  PostReport(this.repository);

  Future<Either<Failure, Report>> execute(String token, ReportRequest report) {
    return repository.postReport(token, report);
  }
}
