import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/models/report_response.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class GetReport {
  final Repository repository;

  GetReport(this.repository);

  Future<Either<Failure, UserReport>> execute(String token, String id) {
    return repository.getReport(token, id);
  }
}
