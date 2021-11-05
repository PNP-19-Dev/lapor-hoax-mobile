import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/user.dart';
import '../repositories/repository.dart';

class GetUser {
  final Repository repository;

  GetUser(this.repository);

  Future<Either<Failure, User>> execute(String email) {
    return repository.getUser(email);
  }
}
