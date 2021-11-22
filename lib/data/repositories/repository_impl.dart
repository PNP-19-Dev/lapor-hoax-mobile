/*
 * Created by andii on 22/11/21 14.56
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 17/11/21 18.26
 */

import 'package:dartz/dartz.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/data/models/category_table.dart';
import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/data/models/question_table.dart';
import 'package:laporhoax/data/models/register.dart';
import 'package:laporhoax/data/models/register_model.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/domain/entities/register_data.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/domain/entities/user_token.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/exception.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:laporhoax/utils/network_exceptions.dart';
import 'package:laporhoax/utils/network_info_impl.dart';

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
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
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
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCategory();
        localDataSource.cacheCategory(
            result.map((category) => CategoryTable.fromDTO(category)).toList());
        return Right(result.map((e) => e.toEntity()).toList());
      } on NetworkExceptions catch (e) {
        return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
      }
    } else {
      try {
        final result = await localDataSource.getCachedCategory();
        return Right(result.map((e) => e.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Report>>> getReports(String token, int id) async {
    try {
      final result = await remoteDataSource.getReport(token, id);
      return Right(result.map((data) => data.toEntity()).toList());
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, User>> getUser(String email) async {
    try {
      final result = await remoteDataSource.getUser(email);
      return Right(result.toEntity());
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, UserToken>> postLogin(String username, String password) async {
    try {
      final result = await remoteDataSource.postLogin(username, password);
      return Right(result.toEntity());
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, RegisterData>> postRegister(Register user) async {
    try {
      final result =
      await remoteDataSource.postRegister(RegisterModel.fromDTO(user));
      return Right(result.toEntity());
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, Report>> postReport(String token, ReportRequest report) async {
    try {
      final result = await remoteDataSource.postReport(token, report);
      return Right(result.toEntity());
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, String>> postUserChallenge(UserQuestion challenge) async {
    try {
      final result = await remoteDataSource
          .postChallenge(UserQuestionModel.fromDTO(challenge));
      return Right(result);
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, String>> deleteReport(String token, int id) async {
    try {
      final result = await remoteDataSource.deleteReport(token, id);
      return Right(result);
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, String>> getPasswordReset(String email) async {
    try {
      final result = await remoteDataSource.getPasswordReset(email);
      return Right(result);
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestions() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getQuestions();
        localDataSource.cacheQuestions(
            result.map((question) => QuestionTable.fromDTO(question)).toList());
        return Right(result.map((e) => e.toEntity()).toList());
      } on NetworkExceptions catch (e) {
        return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
      }
    } else {
      try {
        final result = await localDataSource.getCachedQuestion();
        return Right(result.map((e) => e.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, String>> putPassword(String oldPass, String newPass, String token) async {
    try {
      final result =
      await remoteDataSource.putPassword(oldPass, newPass, token);
      return Right(result);
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, String>> postFCMToken(int user, String? fcmToken) async {
    try {
      final result =
      await remoteDataSource.postFcmToken(user.toString(), fcmToken);
      return Right(result);
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, String>> putFCMToken(int user, String fcmToken) async {
    try {
      final result =
      await remoteDataSource.putFcmToken(user.toString(), fcmToken);
      return Right(result);
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
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
  Future<Either<Failure, UserQuestion>> getUserChallenge(int id) async {
    try {
      final result = await remoteDataSource.getUserQuestions(id);
      return Right(result.toEntity());
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, Feed>> getFeedDetail(int id) async {
    try {
      final result = await remoteDataSource.getFeedDetail(id);
      return Right(result.toEntity());
    } on NetworkExceptions catch (e) {
      return Left(ServerFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  @override
  Future<bool> isDark() async {
    return localDataSource.isDark();
  }

  @override
  Future<bool> setDark(bool value) {
    localDataSource.setDark(value);
    final result = localDataSource.isDark();
    return result;
  }

  @override
  Future<bool> setSession({SessionData? data}) async {
    final result = await localDataSource.setSession(data: data);
    return result;
  }
}
