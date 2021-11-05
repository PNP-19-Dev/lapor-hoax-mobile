import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class GetUserChallenge {
  final Repository repository;

  GetUserChallenge(this.repository);

  Future<Either<Failure, UserQuestion>> execute(int id) {
    return repository.getUserChallenge(id);
  }
}
