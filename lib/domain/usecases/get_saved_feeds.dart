import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class GetSavedFeeds {
  final Repository repository;

  GetSavedFeeds(this.repository);

  Future<Either<Failure, List<Feed>>> execute() {
    return repository.getSavedFeeds();
  }
}
