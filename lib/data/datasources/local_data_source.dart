/*
 * Created by andii on 16/11/21 22.37
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 21.07
 */

import 'package:laporhoax/data/datasources/db/database_helper.dart';
import 'package:laporhoax/data/datasources/preferences/preferences_helper.dart';
import 'package:laporhoax/data/models/category_table.dart';
import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/data/models/question_table.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/utils/exception.dart';

abstract class LocalDataSource {
  static const String saveMessage = 'Feed Saved';
  static const String removeMessage = 'Feed Removed';
  static const String cacheError = "Can't get the data :(";

  Future<String> insertFeed(FeedTable feed);
  Future<String> removeFeed(FeedTable feed);
  Future<FeedTable?> getFeedById(int id);
  Future<List<FeedTable>> getFeeds();
  Future<SessionData?> getSession();
  Future<bool> setSession({SessionData? data});
  Future<void> cacheQuestions(List<QuestionTable> questions);
  Future<List<QuestionTable>> getCachedQuestion();
  Future<void> cacheCategory(List<CategoryTable> category);
  Future<List<CategoryTable>> getCachedCategory();
  Future<bool> isDark();
  Future<bool> setDark(bool value);
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
      return LocalDataSource.saveMessage;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeFeed(FeedTable feed) async {
    try {
      await databaseHelper.removeFeed(feed);
      return LocalDataSource.removeMessage;
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
      throw CacheException(LocalDataSource.cacheError);
    }
  }

  @override
  Future<List<QuestionTable>> getCachedQuestion() async {
    final result = await databaseHelper.getQuestionCache();
    if (result.length > 0) {
      return result.map((data) => QuestionTable.fromMap(data)).toList();
    } else {
      throw CacheException(LocalDataSource.cacheError);
    }
  }

  @override
  Future<bool> isDark() async {
    final result = await preferencesHelper.isDark;
    return result;
  }

  @override
  Future<bool> setDark(bool value) async {
    preferencesHelper.setDark(value);

    final result = await preferencesHelper.isDark;
    return result;
  }

  @override
  Future<bool> setSession({SessionData? data}) async {
    if (data != null) {
      preferencesHelper.setId(value: data.userid);
      preferencesHelper.setExpire(value: data.expiry);
      preferencesHelper.setToken(value: data.token);
      preferencesHelper.setEmail(value: data.email);
      preferencesHelper.setUsername(value: data.username);
      preferencesHelper.setLogin(true);
    } else {
      preferencesHelper.setId();
      preferencesHelper.setExpire();
      preferencesHelper.setToken();
      preferencesHelper.setEmail();
      preferencesHelper.setUsername();
      preferencesHelper.setLogin(false);
    }

    final result = await preferencesHelper.isLogin;
    return result;
  }
}
