import 'package:core/domain/entities/feed.dart';
import 'package:core/domain/repositories/repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetSavedFeeds {
  final Repository repository;

  GetSavedFeeds(this.repository);

  Future<Either<Failure, List<Feed>>> execute() {
    return repository.getSavedFeeds();
  }
}
