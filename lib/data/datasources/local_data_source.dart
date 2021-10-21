import 'package:laporhoax/common/exception.dart';
import 'package:laporhoax/data/datasources/db/database_helper.dart';
import 'package:laporhoax/data/datasources/preferences/preferences_helper.dart';
import 'package:laporhoax/data/models/feed_table.dart';
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
    final result = await databaseHelper.getLastSessions();
    if (result != null) {
      return SessionData.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<String> insertSession(SessionData data) async {
    try {
      await databaseHelper.insertSession(data);
      return 'Session Saved';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeSession(SessionData data) async {
    try {
      await databaseHelper.removeSession(data);
      return 'Session Saved';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
