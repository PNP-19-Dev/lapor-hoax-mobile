import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class DeleteReport {
  final Repository repository;

  DeleteReport(this.repository);

  Future<Either<Failure, String>> execute(String token, int id) {
    return repository.deleteReport(token, id);
  }
}
