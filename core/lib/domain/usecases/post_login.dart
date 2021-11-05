import 'package:dartz/dartz.dart';

import '../../data/models/user_token.dart';
import '../../utils/failure.dart';
import '../repositories/repository.dart';

class PostLogin {
  final Repository repository;

  PostLogin(this.repository);

  Future<Either<Failure, UserToken>> execute(String username, String password) {
    return repository.postLogin(username, password);
  }
}
