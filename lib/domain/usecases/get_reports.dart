import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class GetReports {
  final Repository repository;

  GetReports(this.repository);

  Future<Either<Failure, List<Report>>> execute(String token, int id) {
    return repository.getReports(token, id);
  }
}
