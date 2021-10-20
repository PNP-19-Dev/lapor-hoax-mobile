import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/models/category.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class GetCategories {
  final Repository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<Category>>> execute() {
    return repository.getCategories();
  }
}
