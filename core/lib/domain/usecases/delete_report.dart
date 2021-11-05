import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../repositories/repository.dart';

class DeleteReport {
  final Repository repository;

  DeleteReport(this.repository);

  Future<Either<Failure, String>> execute(String token, int id) {
    return repository.deleteReport(token, id);
  }
}
