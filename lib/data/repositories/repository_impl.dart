import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/exception.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/data/models/register_model.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/user_response.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
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
  Future<bool> isSessionActivated() async {
    return await localDataSource.isLoggedIn();
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
  Future<Either<Failure, List<Report>>> getReports(String token, int id) async {
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
      final result = await remoteDataSource.getUser(email);
      return Right(result.map((e) => e.toEntity()).first);
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
  Future<Either<Failure, UserResponse>> postRegister(RegisterModel user) async {
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
      String token, ReportRequest report) async {
    try {
      final result = await remoteDataSource.postReport(token, report);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, String>> postUserChallenge(
      UserQuestion challenge) async {
    try {
      final result = await remoteDataSource.postChallenge(challenge);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteReport(String token, int id) async {
    try {
      final result = await remoteDataSource.deleteReport(token, id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, String>> getPasswordReset(
      String email, String token) async {
    try {
      final result = await remoteDataSource.getPasswordReset(email, token);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestions() async {
    try {
      final result = await remoteDataSource.getQuestions();
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, String>> postChangePassword(
      String oldPass, String newPass, String token) async {
    try {
      final result =
          await remoteDataSource.postChangePassword(oldPass, newPass, token);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, String>> postFCMToken(
      int user, String fcmToken) async {
    try {
      final result =
          await remoteDataSource.postFcmToken(user.toString(), fcmToken);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, SessionData?>> getSessionData() async {
    try {
      final result = await localDataSource.getSession();
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> removeSessionData(SessionData data) async {
    try {
      final result = await localDataSource.removeSession(data);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> saveSessionData(SessionData data) async {
    try {
      final result = await localDataSource.insertSession(data);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> updateSessionData(SessionData data) {
    // TODO: implement updateSessionData
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserQuestion>> getUserChallenge(int id) async {
    try {
      final result = await remoteDataSource.getUserQuestions(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, Feed>> getFeedDetail(int id) async {
    try {
      final result = await remoteDataSource.getFeedDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }
}
