import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class SaveFeed {
  final Repository repository;

  SaveFeed(this.repository);

  Future<Either<Failure, String>> execute(Feed feed) {
    return repository.saveFeed(feed);
  }
}
