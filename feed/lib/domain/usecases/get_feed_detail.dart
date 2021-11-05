import 'package:core/domain/entities/feed.dart';
import 'package:core/domain/repositories/repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetFeedDetail {
  final Repository repository;

  GetFeedDetail(this.repository);

  Future<Either<Failure, Feed>> execute(int id) {
    return repository.getFeedDetail(id);
  }
}
