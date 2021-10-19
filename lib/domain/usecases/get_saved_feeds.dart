import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class GetSavedFeeds {
  final Repository repository;

  GetSavedFeeds(this.repository);

  Future<Either<Failure, List<Feed>>> execute() {
    return repository.getSavedFeeds();
  }
}
