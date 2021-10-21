import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class GetQuestions {
  final Repository repository;

  GetQuestions(this.repository);

  Future<Either<Failure, List<Question>>> execute() {
    return repository.getQuestions();
  }
}
