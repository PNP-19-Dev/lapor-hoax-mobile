import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class GetPasswordReset {
  final Repository repository;

  GetPasswordReset(this.repository);

  Future<Either<Failure, String>> execute(String email) {
    return repository.getPasswordReset(email);
  }
}
