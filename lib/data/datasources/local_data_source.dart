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

  Future<List<String>> getSessionData();

  void setSessionData(SessionData data);
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
  Future<List<String>> getSessionData() async {
    return await preferencesHelper.sessionData;
  }

  @override
  void setSessionData(SessionData? data) {
    preferencesHelper.setSessionData(data!.userToken);
    preferencesHelper.setUserData(data.data);
  }
}
