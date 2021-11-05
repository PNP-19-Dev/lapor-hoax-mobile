import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class GetPasswordReset {
  final Repository repository;

  GetPasswordReset(this.repository);

  Future<Either<Failure, String>> execute(String email) {
    return repository.getPasswordReset(email);
  }
}
