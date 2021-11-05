import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/category.dart';
import '../repositories/repository.dart';

class GetCategories {
  final Repository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<Category>>> execute() {
    return repository.getCategories();
  }
}
