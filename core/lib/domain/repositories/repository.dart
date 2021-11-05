import 'package:dartz/dartz.dart';

import '../../../data/models/register_model.dart';
import '../../../data/models/report_request.dart';
import '../../../data/models/user_response.dart';
import '../../../data/models/user_token.dart';
import '../../../utils/failure.dart';
import '../entities/category.dart';
import '../entities/feed.dart';
import '../entities/question.dart';
import '../entities/report.dart';
import '../entities/session_data.dart';
import '../entities/user.dart';
import '../entities/user_question.dart';

abstract class Repository {
  Future<Either<Failure, String>> deleteReport(String token, int id);
  Future<Either<Failure, List<Category>>> getCategories();
  Future<bool> isAddedToSavedFeed(int id);
  Future<bool> isSessionActivated();
  Future<Either<Failure, List<Feed>>> getFeeds();
  Future<Either<Failure, Feed>> getFeedDetail(int id);
  Future<Either<Failure, String>> getPasswordReset(String email);
  Future<Either<Failure, List<Question>>> getQuestions();
  Future<Either<Failure, List<Report>>> getReports(String token, int id);
  Future<Either<Failure, List<Feed>>> getSavedFeeds();
  Future<Either<Failure, SessionData>> getSessionData();
  Future<Either<Failure, User>> getUser(String email);
  Future<Either<Failure, UserQuestion>> getUserChallenge(int id);
  Future<Either<Failure, String>> postChangePassword(
      String oldPass, String newPass, String token);
  Future<Either<Failure, String>> postFCMToken(int user, String fcmToken);
  Future<Either<Failure, String>> putFCMToken(int user, String fcmToken);
  Future<Either<Failure, UserToken>> postLogin(
      String username, String password);
  Future<Either<Failure, UserResponse>> postRegister(RegisterModel user);
  Future<Either<Failure, Report>> postReport(
      String token, ReportRequest report);
  Future<Either<Failure, String>> postUserChallenge(UserQuestion challenge);
  Future<Either<Failure, String>> removeFeed(Feed feed);
  Future<Either<Failure, String>> removeSessionData(SessionData data);
  Future<Either<Failure, String>> saveFeed(Feed feed);
  Future<Either<Failure, String>> saveSessionData(SessionData data);
}