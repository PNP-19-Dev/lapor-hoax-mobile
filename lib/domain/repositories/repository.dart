import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/models/category.dart';
import 'package:laporhoax/data/models/feed_model.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/report_response.dart';
import 'package:laporhoax/data/models/user_data.dart';
import 'package:laporhoax/data/models/user_register.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/entities/feed.dart';

abstract class Repository {
  Future<Either<Failure, UserToken>> postLogin();

  Future<Either<Failure, UserRegister>> postRegister();

  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<User>>> getUser(String email);

  Future<Either<Failure, UserReport>> getReport(String token, String id);

  Future<Either<Failure, ReportRequest>> postReport(
      String token, ReportRequest report);

  Future<Either<Failure, List<FeedModel>>> getFeeds();

  Future<Either<Failure, String>> saveFeed(Feed feed);

  Future<Either<Failure, String>> removeFeed(Feed feed);

  Future<bool> isAddedToSavedFeed(int id);

  Future<Either<Failure, List<Feed>>> getSavedFeeds();
}
