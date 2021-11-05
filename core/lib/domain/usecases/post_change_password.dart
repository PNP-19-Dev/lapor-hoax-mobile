import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../repositories/repository.dart';

class PostChangePassword {
  final Repository repository;

  PostChangePassword(this.repository);

  Future<Either<Failure, String>> execute(
      String oldPass, String newPass, String token) {
    return repository.postChangePassword(oldPass, newPass, token);
  }
}
