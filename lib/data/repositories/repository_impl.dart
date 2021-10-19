import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/exception.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/data/models/feed_model.dart';
import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  RepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<FeedModel>>> getFeeds() async {
    try {
      final result = await remoteDataSource.getFeeds();
      return Right(result.map((data) => data.entity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> saveFeed(Feed feed) async {
    try {
      final result =
          await localDataSource.insertFeed(FeedTable.fromEntity(feed));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> isAddedToSavedFeed(int id) async {
    final result = await localDataSource.getFeedById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Feed>>> getSavedFeeds() async {
    final result = await localDataSource.getFeeds();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<Either<Failure, String>> removeFeed(Feed feed) async {
    try {
      final result =
          await localDataSource.removeFeed(FeedTable.fromEntity(feed));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
