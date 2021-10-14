import 'package:flutter/material.dart';
import 'package:laporhoax/data/db/database_helper.dart';
import 'package:laporhoax/data/model/feed.dart';
import 'package:laporhoax/util/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getNews();
  }

  late ResultState _state;

  ResultState get state => _state;

  String _message = '';

  String get message => _message;

  List<Feed> _news = [];

  List<Feed> get news => _news;

  void _getNews() async {
    _news = await databaseHelper.getFeeds();
    if (_news.length > 0) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Data Kosong';
    }
    notifyListeners();
  }

  void saveFeed(Feed feed) async {
    try {
      await databaseHelper.insertNews(feed);
      _getNews();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isSaved(String id) async {
    final savedFeed = await databaseHelper.getFeedById(id);
    return savedFeed.isNotEmpty;
  }

  void removeFeed(String id) async {
    try {
      await databaseHelper.removeNews(id);
      _getNews();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
