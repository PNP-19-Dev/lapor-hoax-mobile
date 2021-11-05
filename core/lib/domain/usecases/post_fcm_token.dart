import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../repositories/repository.dart';

class PostFCMToken {
  final Repository repository;

  PostFCMToken(this.repository);

  Future<Either<Failure, String>> execute(int user, String fcmToken) {
    return repository.postFCMToken(user, fcmToken);
  }
}
