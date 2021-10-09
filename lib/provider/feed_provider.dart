import 'package:flutter/cupertino.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/feed.dart';
import 'package:laporhoax/util/result_state.dart';

class FeedProvider extends ChangeNotifier {
  final LaporhoaxApi apiService;

  FeedProvider({required this.apiService}) {
    _getFeed();
  }

  String _message = '';
  int _count = 0;
  late Feeds _feeds;
  late ResultState _state;

  Feeds get feeds => _feeds;

  String get message => _message;

  int get count => _count;

  ResultState get state => _state;

  Future<dynamic> _getFeed() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final feed = await apiService.getFeeds();
      if (feed.results.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        _count = feed.count;
        return _feeds = feed;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error ---> $e';
    }
  }

  Future<dynamic> updateFeed(String page) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final feed = await apiService.getFeeds(page: page);

      if (feed.results.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _feeds = feed;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error ---> $e';
    }
  }
}
