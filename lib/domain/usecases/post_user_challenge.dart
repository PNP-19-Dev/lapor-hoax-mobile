import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/models/challenge.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class PostUserChallenge {
  final Repository repository;

  PostUserChallenge(this.repository);

  Future<Either<Failure, Challenge>> execute(Challenge challenge) {
    return repository.postUserChallenge(challenge);
  }
}
