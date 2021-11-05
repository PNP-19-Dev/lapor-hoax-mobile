import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../repositories/repository.dart';

class GetPasswordReset {
  final Repository repository;

  GetPasswordReset(this.repository);

  Future<Either<Failure, String>> execute(String email) {
    return repository.getPasswordReset(email);
  }
}
