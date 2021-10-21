import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class PostLogin {
  final Repository repository;

  PostLogin(this.repository);

  Future<Either<Failure, UserToken>> execute(String username, String password) {
    return repository.postLogin(username, password);
  }
}
