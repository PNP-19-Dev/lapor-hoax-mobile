import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/question.dart';
import '../repositories/repository.dart';

class GetQuestions {
  final Repository repository;

  GetQuestions(this.repository);

  Future<Either<Failure, List<Question>>> execute() {
    return repository.getQuestions();
  }
}
