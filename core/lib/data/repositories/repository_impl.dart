import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/feed.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/session_data.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_question.dart';
import '../../domain/repositories/repository.dart';
import '../../utils/NetworkInfoImpl.dart';
import '../../utils/exception.dart';
import '../../utils/failure.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/feed_table.dart';
import '../models/register_model.dart';
import '../models/report_request.dart';
import '../models/user_response.dart';
import '../models/user_token.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Feed>>> getFeeds() async {
    try {
      final result = await remoteDataSource.getFeeds();
      return Right(result.map((data) => data.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Cant Retrieve Feed Data'));
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
      rethrow;
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
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCategory();
        localDataSource.cacheCategory(
            result.map((category) => Category.fromDTO(category)).toList());
        return Right(result.map((e) => e.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure("Cant Fetch Categories"));
      } on SocketException {
        return Left(ConnectionFailure("Failed to connect to the network"));
      }
    } else {
      final result = await localDataSource.getCachedCategory();
      return Right(result.map((e) => e.toEntity()).toList());
    }
  }

  @override
  Future<Either<Failure, List<Report>>> getReports(String token, int id) async {
    try {
      final result = await remoteDataSource.getReport(token, id);
      return Right(result.map((data) => data.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure("Cant Fetch Reports"));
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
      return Left(ServerFailure("Not Found"));
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
      return Left(ServerFailure("UserName atau Password Salah!"));
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
      return Left(ServerFailure("Invalid Data"));
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
      return Left(ServerFailure("Invalid"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, String>> postUserChallenge(
      UserQuestion challenge) async {
    try {
      final result = await remoteDataSource.postChallenge(challenge);
      print('Challenge Result $result');
      return Right(result);
    } on ServerException {
      return Left(ServerFailure("Invalid"));
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
      return Left(ServerFailure("Cant Delete Report"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, String>> getPasswordReset(String email) async {
    try {
      final result = await remoteDataSource.getPasswordReset(email);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure("Cant Reset"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestions() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getQuestions();
        localDataSource.cacheQuestions(
            result.map((question) => Question.fromDTO(question)).toList());
        return Right(result.map((e) => e.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure("Cant Retrieve Data"));
      } on SocketException {
        return Left(ConnectionFailure("Failed to connect to the network"));
      }
    } else {
      final result = await localDataSource.getCachedQuestion();
      return Right(result.map((e) => e.toEntity()).toList());
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
      return Left(ServerFailure("Cant Change Password"));
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
      return Left(ServerFailure("Cant To Send"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, String>> putFCMToken(int user, String fcmToken) async {
    try {
      final result =
      await remoteDataSource.updateFcmToken(user.toString(), fcmToken);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure("Cant To Send"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, SessionData>> getSessionData() async {
    final result = await localDataSource.getSession();
    if (result != null) {
      return Right(result);
    } else {
      return Left(CustomException('No Data'));
    }
  }

  @override
  Future<Either<Failure, String>> removeSessionData(SessionData data) async {
    final result = await localDataSource.removeSession(data);
    if (result == 'Session Removed') {
      return Right(result);
    } else {
      return Left(CustomException('No Data'));
    }
  }

  @override
  Future<Either<Failure, String>> saveSessionData(SessionData data) async {
    final result = await localDataSource.insertSession(data);
    if (result == 'Session Saved') {
      return Right(result);
    } else {
      return Left(CustomException('No Data'));
    }
  }

  @override
  Future<Either<Failure, UserQuestion>> getUserChallenge(int id) async {
    try {
      final result = await remoteDataSource.getUserQuestions(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure("Failed to Get Data"));
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
      return Left(ServerFailure("Failed To Get Detail"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }
}