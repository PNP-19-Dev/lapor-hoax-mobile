import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/user_question.dart';
import '../repositories/repository.dart';

class GetUserChallenge {
  final Repository repository;

  GetUserChallenge(this.repository);

  Future<Either<Failure, UserQuestion>> execute(int id) {
    return repository.getUserChallenge(id);
  }
}
