import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class RemoveSessionData {
  final Repository repository;

  RemoveSessionData(this.repository);

  Future<Either<Failure, String>> execute() {
    return repository.removeSessionData();
  }
}
