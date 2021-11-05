import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class GetUser {
  final Repository repository;

  GetUser(this.repository);

  Future<Either<Failure, User>> execute(String email) {
    return repository.getUser(email);
  }
}
