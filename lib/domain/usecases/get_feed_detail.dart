import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class GetFeedDetail {
  final Repository repository;

  GetFeedDetail(this.repository);

  Future<Either<Failure, Feed>> execute(int id) {
    return repository.getFeedDetail(id);
  }
}
