import '../../../domain/entities/category.dart';
import '../../../domain/entities/question.dart';
import '../../../domain/entities/session_data.dart';
import '../../../utils/exception.dart';
import '../models/feed_table.dart';
import 'db/database_helper.dart';
import 'preferences/preferences_helper.dart';

abstract class LocalDataSource {
  Future<String> insertFeed(FeedTable feed);
  Future<String> removeFeed(FeedTable feed);
  Future<FeedTable?> getFeedById(int id);
  Future<List<FeedTable>> getFeeds();
  Future<bool> isLoggedIn();
  Future<SessionData?> getSession();
  Future<String> insertSession(SessionData data);
  Future<String> removeSession(SessionData data);
  Future<void> cacheQuestions(List<Question> questions);
  Future<List<Question>> getCachedQuestion();
  Future<void> cacheCategory(List<Category> category);
  Future<List<Category>> getCachedCategory();
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
  Future<void> cacheCategory(List<Category> categories) async {
    await databaseHelper.clearCategoryCache();
    await databaseHelper.insertCategoryTransaction(categories);
  }

  @override
  Future<void> cacheQuestions(List<Question> questions) async {
    await databaseHelper.clearQuestionCache();
    await databaseHelper.insertQuestionTransaction(questions);
  }

  @override
  Future<List<Category>> getCachedCategory() async {
    final result = await databaseHelper.getCategoryCache();
    if (result.isNotEmpty) {
      return result.map((data) => Category.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<List<Question>> getCachedQuestion() async {
    final result = await databaseHelper.getQuestionCache();
    if (result.isNotEmpty) {
      return result.map((data) => Question.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}