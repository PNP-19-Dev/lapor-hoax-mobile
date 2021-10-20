import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/exception.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/data/models/user_response.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  RepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<Feed>>> getFeeds() async {
    try {
      final result = await remoteDataSource.getFeeds();
      return Right(result.map((data) => data.toEntity()).toList());
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

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategory();
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, List<Report>>> getReports(
      String token, String id) async {
    try {
      final result = await remoteDataSource.getReport(token, id);
      return Right(result.map((data) => data.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, User>> getUser(String email) async {
    try {
      final result = await remoteDataSource.getUserData(email);
      return Right(result.first);
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, UserToken>> postLogin(
      String username, String password) async {
    try {
      final result = await remoteDataSource.postLogin(username, password);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, UserRegister>> postRegister() {
    try {
      final result = await remoteDataSource.postRegister(user);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, Report>> postReport(
      String token, ReportRequest report) {
    // TODO: implement postReport
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserQuestion>> postUserChallenge(
      UserQuestionModel challenge) {
    // TODO: implement postUserChallenge
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> deleteReport(String token, Report report) {
    throw UnimplementedError();
  }
}
