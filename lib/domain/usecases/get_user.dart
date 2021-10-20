import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/entities/User.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class GetUser {
  final Repository repository;

  GetUser(this.repository);

  Future<Either<Failure, User>> execute(String email) {
    return repository.getUser(email);
  }
}
