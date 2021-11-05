import 'package:dartz/dartz.dart';

import '../../domain/repositories/repository.dart';
import '../../utils/failure.dart';

class PutFCMToken {
  final Repository repository;

  PutFCMToken(this.repository);

  Future<Either<Failure, String>> execute(int user, String fcmToken) {
    return repository.putFCMToken(user, fcmToken);
  }
}
