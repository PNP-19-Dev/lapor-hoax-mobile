import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/user_question.dart';
import '../repositories/repository.dart';

class PostUserChallenge {
  final Repository repository;

  PostUserChallenge(this.repository);

  Future<Either<Failure, String>> execute(UserQuestion challenge) {
    return repository.postUserChallenge(challenge);
  }
}
