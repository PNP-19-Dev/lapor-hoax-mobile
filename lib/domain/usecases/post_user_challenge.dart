import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class PostUserChallenge {
  final Repository repository;

  PostUserChallenge(this.repository);

  Future<Either<Failure, UserQuestionModel>> execute(
      UserQuestionModel challenge) {
    return repository.postUserChallenge(challenge);
  }
}
