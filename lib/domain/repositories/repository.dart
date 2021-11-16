/*
 * Created by andii on 17/11/21 00.28
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 23.41
 */

import 'package:dartz/dartz.dart';
import 'package:laporhoax/data/models/register.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/domain/entities/register_data.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/domain/entities/user_token.dart';
import 'package:laporhoax/utils/failure.dart';

abstract class Repository {
  Future<Either<Failure, String>> deleteReport(String token, int id);
  Future<Either<Failure, List<Category>>> getCategories();
  Future<bool> isAddedToSavedFeed(int id);
  Future<Either<Failure, List<Feed>>> getFeeds();
  Future<Either<Failure, Feed>> getFeedDetail(int id);
  Future<Either<Failure, String>> getPasswordReset(String email);
  Future<Either<Failure, List<Question>>> getQuestions();
  Future<Either<Failure, List<Report>>> getReports(String token, int id);
  Future<Either<Failure, List<Feed>>> getSavedFeeds();
  Future<Either<Failure, SessionData>> getSessionData();
  Future<Either<Failure, User>> getUser(String email);
  Future<Either<Failure, UserQuestion>> getUserChallenge(int id);
  Future<Either<Failure, String>> putPassword(
      String oldPass, String newPass, String token);
  Future<Either<Failure, String>> postFCMToken(int user, String? fcmToken);
  Future<Either<Failure, String>> putFCMToken(int user, String fcmToken);
  Future<Either<Failure, UserToken>> postLogin(
      String username, String password);
  Future<Either<Failure, RegisterData>> postRegister(Register user);
  Future<Either<Failure, Report>> postReport(
      String token, ReportRequest report);
  Future<Either<Failure, String>> postUserChallenge(UserQuestion challenge);
  Future<Either<Failure, String>> removeFeed(Feed feed);
  Future<Either<Failure, String>> saveFeed(Feed feed);
  Future<bool> setSession({SessionData? data});
}
