import 'package:core/domain/entities/feed.dart';
import 'package:core/domain/repositories/repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class SaveFeed {
  final Repository repository;

  SaveFeed(this.repository);

  Future<Either<Failure, String>> execute(Feed feed) {
    return repository.saveFeed(feed);
  }
}
