import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class GetFeeds {
  final Repository repository;

  GetFeeds(this.repository);

  Future<Either<Failure, List<Feed>>> execute() {
    return repository.getFeeds();
  }
}
