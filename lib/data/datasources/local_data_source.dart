import 'package:laporhoax/common/exception.dart';
import 'package:laporhoax/data/datasources/db/database_helper.dart';
import 'package:laporhoax/data/datasources/preferences/preferences_helper.dart';
import 'package:laporhoax/data/models/category_table.dart';
import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/data/models/question_table.dart';
import 'package:laporhoax/domain/entities/session_data.dart';

abstract class LocalDataSource {
  Future<String> insertFeed(FeedTable feed);
  Future<String> removeFeed(FeedTable feed);
  Future<FeedTable?> getFeedById(int id);
  Future<List<FeedTable>> getFeeds();
  Future<bool> isLoggedIn();
  Future<SessionData?> getSession();
  Future<String> insertSession(SessionData data);
  Future<String> removeSession(SessionData data);
  Future<void> cacheQuestions(List<QuestionTable> questions);
  Future<List<QuestionTable>> getCachedQuestion();
  Future<void> cacheCategory(List<CategoryTable> category);
  Future<List<CategoryTable>> getCachedCategory();
}

class LocalDataSourceImpl implements LocalDataSource {
  final DatabaseHelper databaseHelper;
  final PreferencesHelper preferencesHelper;

  LocalDataSourceImpl({
    required this.databaseHelper,
    required this.preferencesHelper,
  });

  @override
  Future<String> insertFeed(FeedTable feed) async {
    try {
      await databaseHelper.insertNews(feed);
      return 'Feed Saved';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeFeed(FeedTable feed) async {
    try {
      await databaseHelper.removeFeed(feed);
      return 'Feed Removed';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<FeedTable>> getFeeds() async {
    final result = await databaseHelper.getFeeds();
    return result.map((data) => FeedTable.fromMap(data)).toList();
  }

  @override
  Future<FeedTable?> getFeedById(int id) async {
    final result = await databaseHelper.getFeedById(id);
    if (result != null) {
      return FeedTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await preferencesHelper.isLogin;
  }

  @override
  Future<SessionData?> getSession() async {
    final status = await preferencesHelper.isLogin;
    final id = await preferencesHelper.id;
    final token = await preferencesHelper.token;
    final expiry = await preferencesHelper.expireDate;
    final email = await preferencesHelper.email;
    final username = await preferencesHelper.username;

    if (status) {
      return SessionData(
        userid: id,
        token: token,
        expiry: expiry,
        email: email,
        username: username,
      );
    } else {
      return null;
    }
  }

  @override
  Future<String> insertSession(SessionData data) async {
    preferencesHelper.setId(data.userid);
    preferencesHelper.setExpire(data.expiry);
    preferencesHelper.setToken(data.token);
    preferencesHelper.setEmail(data.email);
    preferencesHelper.setUsername(data.username);
    preferencesHelper.setLogin(true);
    return 'Session Saved';
  }

  @override
  Future<String> removeSession(SessionData data) async {
    preferencesHelper.setId(-1);
    preferencesHelper.setExpire(null);
    preferencesHelper.setToken(null);
    preferencesHelper.setEmail(null);
    preferencesHelper.setUsername(null);
    preferencesHelper.setLogin(false);
    return 'Session Removed';
  }

  @override
  Future<void> cacheCategory(List<CategoryTable> categories) async {
    await databaseHelper.clearCategoryCache();
    await databaseHelper.insertCategoryTransaction(categories);
  }

  @override
  Future<void> cacheQuestions(List<QuestionTable> questions) async {
    await databaseHelper.clearQuestionCache();
    await databaseHelper.insertQuestionTransaction(questions);
  }

  @override
  Future<List<CategoryTable>> getCachedCategory() async {
    final result = await databaseHelper.getCategoryCache();
    if (result.length > 0) {
      return result.map((data) => CategoryTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<List<QuestionTable>> getCachedQuestion() async {
    final result = await databaseHelper.getQuestionCache();
    if (result.length > 0) {
      return result.map((data) => QuestionTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}
