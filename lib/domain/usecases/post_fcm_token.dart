import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class PostFCMToken {
  final Repository repository;

  PostFCMToken(this.repository);

  Future<Either<Failure, String>> execute(int user, String fcmToken) {
    return repository.postFCMToken(user, fcmToken);
  }
}
