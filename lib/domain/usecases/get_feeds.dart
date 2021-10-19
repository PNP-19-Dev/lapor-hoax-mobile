import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/models/feed_model.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class GetFeeds {
  final Repository repository;

  GetFeeds(this.repository);

  Future<Either<Failure, List<FeedModel>>> execute() {
    return repository.getFeeds();
  }
}
