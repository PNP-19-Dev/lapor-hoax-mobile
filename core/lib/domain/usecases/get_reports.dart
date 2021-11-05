import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/report.dart';
import '../repositories/repository.dart';

class GetReports {
  final Repository repository;

  GetReports(this.repository);

  Future<Either<Failure, List<Report>>> execute(String token, int id) {
    return repository.getReports(token, id);
  }
}
