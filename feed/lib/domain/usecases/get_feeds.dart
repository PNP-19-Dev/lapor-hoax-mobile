import 'package:core/domain/entities/feed.dart';
import 'package:core/domain/repositories/repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetFeeds {
  final Repository repository;

  GetFeeds(this.repository);

  Future<Either<Failure, List<Feed>>> execute() {
    return repository.getFeeds();
  }
}
