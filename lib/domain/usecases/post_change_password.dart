import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class PostChangePassword {
  final Repository repository;

  PostChangePassword(this.repository);

  Future<Either<Failure, String>> execute(
      String oldPass, String newPass, String token) {
    return repository.postChangePassword(oldPass, newPass, token);
  }
}
